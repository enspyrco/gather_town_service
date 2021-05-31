import 'dart:convert';

import 'package:gather_town_service/services/gather_town_api_service.dart';
import 'package:gather_town_service/utils/saved_objects.dart' as saved_objects;
import 'package:gather_town_service/utils/typedefs.dart';
import 'package:http/http.dart';

final deltaFunctions = {'unblockGame': _unblockGame, 'blockGame': _blockGame};

/// [_map] is set once when the serverless instance starts
///
///
class GatherTownMapService {
  // Private constructor so there is only one option to create the service.
  GatherTownMapService._(GatherTownApiService apiService, GatherTownMap map)
      : _apiService = apiService,
        _map = map,
        _allObjects =
            AllObjects((map['objects'] as List).cast<GatherTownObject>()) {
    _syncMapState();
  }

  final GatherTownApiService _apiService;

  // The call to create makes an async api call to retrieve the current map.
  static Future<GatherTownMapService> create() async {
    final apiService = await GatherTownApiService.create();
    final map = await apiService.retrieveCurrentMap();
    final service = GatherTownMapService._(apiService, map);
    return service;
  }

  // The json for the entire map (objects, collisions, etc.)
  final GatherTownMap _map;

  // On and off screen objects
  final AllObjects _allObjects;

  // Getters.
  bool get isEmpty => _map.isEmpty;
  GatherTownMap getFullMap() => _map;

  // Add off screen objects to removed list, used to check to avoid adding
  // duplicates.
  // Should only be called once on creation of service.
  void _syncMapState() {
    var noBlockGameObjects = true;

    for (final object in _allObjects.mapObjects) {
      final id = object['id'] as String?;
      if (id != null && id.startsWith('block_game')) noBlockGameObjects = false;
    }

    if (noBlockGameObjects) {
      final blockGameObjects = (jsonDecode(saved_objects.blockGame) as List)
          .cast<GatherTownObject>();
      _allObjects.removed['block_game'] = blockGameObjects;
    }
  }

  // Use the delta string to find the relevant function and call it.
  void apply(String delta) => deltaFunctions[delta]!(_allObjects);

  Future<Response> push() => _apiService.pushCurrent(map: _map);
}

/// Keeps track of on and off-screen objects
class AllObjects {
  AllObjects(this.mapObjects);

  final ObjectsList mapObjects;
  final RemovedObjectsMap removed = {};
}

// Removes potted plants from the globalMap and saves them to a separate list
// for later re-insertion.
// TODO: improve performance by keeping objects in a better data structure
void _unblockGame(AllObjects objects) {
  final treesForRemoval = [];

  for (final object in objects.mapObjects) {
    final id = object['id'] as String?;
    if (id != null && id.startsWith('block_game')) {
      treesForRemoval.add(object);
    }
  }

  for (final object in treesForRemoval) {
    objects.mapObjects.remove(object);
  }
}

// Put the potted plants back in the global map
void _blockGame(AllObjects objects) {
  objects.mapObjects.addAll(objects.removed['block_game'] ?? []);
  objects.removed['block_game'] = [];
}
