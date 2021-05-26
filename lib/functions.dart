import 'dart:convert';
import 'dart:io';

import 'package:functions_framework/functions_framework.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart' as shelf;

final client = http.Client();

@CloudFunction()
Future<shelf.Response> function(shelf.Request request) async {
  // return _saveMap('saved.json');

  // return _setMap('original.json');
  return _setMap('updated.json');
}

Future<shelf.Response> _saveMap(String fileName) async {
  final queryParameters =
      json.decode(File('credentials.json').readAsStringSync());
  final getUri = Uri.https('gather.town', '/api/getMap', queryParameters);

  final response = await client.get(getUri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });
  File(fileName).writeAsStringSync(response.body);

  return shelf.Response.ok('Response body saved.');
}

Future<shelf.Response> _setMap(String fileName) async {
  final setUri = Uri.https('gather.town', '/api/setMap');
  final queryParameters =
      json.decode(File('credentials.json').readAsStringSync());
  queryParameters['mapContent'] =
      json.decode(File(fileName).readAsStringSync());
  final response = await client.post(setUri,
      body: json.encode(queryParameters),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'});

  return shelf.Response.ok(response.body);
}
