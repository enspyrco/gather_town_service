import 'package:gather_town_service/utils/locator.dart';
import 'package:gather_town_service/utils/typedefs.dart';

final deltaFunctions = {'showGame': _showGame, 'hideGame': _hideGame};

/// [_map] is set once when the serverless instance starts
class GatherTownMapService {
  // Private constructor so there is only one option to create the service.
  GatherTownMapService._(this._map)
      : _parts = MapParts((_map['objects'] as List).cast<GatherTownObject>());

  // The call to create makes an async api call to retrieve the current map.
  static Future<GatherTownMapService> create() async {
    final apiService = Locator.getApiService();
    final map = await apiService.retrieveCurrentMap();
    return GatherTownMapService._(map);
  }

  final GatherTownMap _map;
  final MapParts _parts;

  bool get isEmpty => _map.isEmpty;
  GatherTownMap getFullMap() => _map;

  void apply(String delta) => deltaFunctions[delta]!(_parts);
}

class MapParts {
  MapParts(this.objects);
  final ObjectsList objects;
  final RemovedObjectsMap removed = {};
}

// Removes potted plants from the globalMap and saves them to a separate list
// for later re-insertion.
void _showGame(MapParts mapParts) {
  final treesForRemoval = [];

  for (final object in mapParts.objects) {
    final id = object['id'] as String?;
    if (id != null && id.contains('Potted Plant')) {
      treesForRemoval.add(object);
    }
  }
  for (final tree in treesForRemoval) {
    mapParts.objects.remove(tree);
  }
}

// Put the potted plants back in the global map
void _hideGame(MapParts mapParts) {
  mapParts.objects.addAll(mapParts.removed['trees'] ?? []);
  mapParts.removed['trees'] = [];
}
