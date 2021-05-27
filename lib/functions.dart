import 'dart:convert';
import 'dart:io';

import 'package:functions_framework/functions_framework.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart' as shelf;

import 'originalJson.dart';
import 'updatedJson.dart';

final client = http.Client();

@CloudFunction()
Future<shelf.Response> function(shelf.Request request) async {
  // return _getMap('saved.json', queryParameters);

  try {
    // Get the gather.town credentials - from local file if running locally
    // or from environment variable if in Cloud Run.
    final envVars = Platform.environment;
    final credentials = envVars['CREDENTIALS'];
    final queryParameters = (credentials != null)
        ? json.decode(credentials)
        : json.decode(File('credentials.json').readAsStringSync());

    // Retrieve the map name from the query parameters.
    final mapName =
        '${request.requestedUri.queryParameters['map'] ?? 'original'}';

    return _setMap(mapName, queryParameters);
  } catch (error, trace) {
    return shelf.Response.ok('Error: $error\n\n$trace');
  }
}

Future<shelf.Response> _getMap(
    String fileName, Map<String, dynamic> queryParameters) async {
  final getUri = Uri.https('gather.town', '/api/getMap', queryParameters);

  final response = await client.get(getUri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });
  File(fileName).writeAsStringSync(response.body);

  return shelf.Response.ok('Response body saved.');
}

Future<shelf.Response> _setMap(
    String mapName, Map<String, dynamic> queryParameters) async {
  final setUri = Uri.https('gather.town', '/api/setMap');

  print('Setting to: $mapName map');
  final mapJson = (mapName == 'original') ? originalJson : updatedJson;
  queryParameters['mapContent'] = json.decode(mapJson);

  final response = await client.post(setUri,
      body: json.encode(queryParameters),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'});

  return shelf.Response.ok(response.body);
}
