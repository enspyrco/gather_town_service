import 'package:functions_framework/functions_framework.dart';
import 'package:gather_town_service/gather_town_api_service.dart';
import 'package:gather_town_service/locator.dart';
import 'package:gather_town_service/typedefs.dart';
import 'package:shelf/shelf.dart';

const deltaFunctions = {'showGame': _showGame, 'hideGame': _hideGame};

GatherTownApiService? apiService;
GatherTownMap? gatherTownMap;
final Map<String, ObjectsList> removedObjects = {};

// We are using a ServiceLocator and nullable globals to hold the service
// and gather town map, so we can easily check what is already available.
// With this strategy, we use ! when we access the globals as the entry point
// will always make sure the globals hold an object as the first thing it does.

// The service locator pattern is useful for testing, in a serverless context
// where we cannot use constructor injection for the top-level function.

@CloudFunction()
Future<Response> function(Request request) async {
  try {
    apiService ??= Locator.getApiService();
    gatherTownMap ??= await apiService!.retrieveCurrentMap();

    // Retrieve the delta from the query and call the corresponding function
    final delta = request.requestedUri.queryParameters['delta'];
    final applyDelta = deltaFunctions[delta];
    if (applyDelta != null) {
      applyDelta();
      return apiService!.setCurrent(map: gatherTownMap!);
    } else {
      return Response.ok('No delta found.');
    }
  } catch (error, trace) {
    return Response.ok('Error: $error\n\n$trace');
  }
}

// Removes potted plants from the globalMap and saves them to a separate list
// for later re-insertion.
void _showGame() {
  final objects = gatherTownMap!['objects'] as ObjectsList;

  removedObjects['trees'] = [];

  for (final object in objects) {
    final id = object['id'] as String?;
    if (id != null && id.contains('Potted Plant')) {
      removedObjects['trees']!.add(object);
    }
  }
  for (final tree in removedObjects['trees']!) {
    objects.remove(tree);
  }
}

// Put the potted plants back in the global map
void _hideGame() {
  final objects = gatherTownMap!['objects'] as ObjectsList;
  objects.addAll(removedObjects['trees'] ?? []);
  removedObjects['trees'] = [];
}
