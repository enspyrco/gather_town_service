import 'dart:convert';
import 'dart:io';

import 'package:functions_framework/functions_framework.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart' as shelf;

const deltaFunctions = {'showGame': _showGame, 'hideGame': _hideGame};

final globalClient = http.Client();
late final getUri;
final setUri = Uri.https('gather.town', '/api/setMap');
late final globalQueryParameters = <String, Object?>{};
var globalMap = <String, Object?>{};
final List<Map<String, Object?>> removedTrees = [];

@CloudFunction()
Future<shelf.Response> function(shelf.Request request) async {
  try {
    await _setGlobalsIfEmpty();

    // Retrieve the delta from the query and call the corresponding function
    final delta = request.requestedUri.queryParameters['delta'];
    final applyDelta = deltaFunctions[delta];
    if (applyDelta != null) {
      applyDelta();
      return _setCurrentMap();
    } else {
      return shelf.Response.ok('No delta found.');
    }
  } catch (error, trace) {
    return shelf.Response.ok('Error: $error\n\n$trace');
  }
}

// Removes potted plants from the globalMap and saves them to a separate list
// for later re-insertion.
void _showGame() {
  final objects = globalMap['objects'] as List<Map<String, Object?>>;

  for (final object in objects) {
    final id = object['id'] as String?;
    if (id != null && id.contains('Potted Plant')) {
      removedTrees.add(object);
    }
  }
  for (final removedTree in removedTrees) {
    objects.remove(removedTree);
  }
}

// Put the potted plants back in the global map
void _hideGame() {
  final objects = globalMap['objects'] as List<Map<String, Object?>>;
  objects.addAll(removedTrees);
  removedTrees.clear();
}

Future<void> _setGlobalsIfEmpty() async {
  if (globalMap.isEmpty) {
    // Get the gather.town credentials - from local file if running locally
    // or from environment variable if in Cloud Run.
    final credentialsString = Platform.environment['CREDENTIALS'] ??
        File('credentials.json').readAsStringSync();
    final credentialsMap = json.decode(credentialsString);
    getUri = Uri.https('gather.town', '/api/getMap', credentialsMap);

    // We also keep a global map of query parameters, to be combined with the
    // current gather.town map data in setMap. Here we add set the credentials.
    globalQueryParameters.addAll(credentialsMap);

    // Retrieve the current gather.town map & store in a global
    final response = await globalClient.get(getUri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    globalMap = json.decode(response.body);
  }
}

Future<shelf.Response> _setCurrentMap() async {
  globalQueryParameters['mapContent'] = globalMap;

  final response = await globalClient.post(setUri,
      body: json.encode(globalQueryParameters),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'});

  return shelf.Response.ok(response.body);
}
