import 'dart:convert';
import 'dart:io';

import 'package:gather_town_service/typedefs.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart' as shelf;

class GatherTownApiService {
  final _client = http.Client();
  late final Map<String, String> _credentials;
  late final Uri _getUri;
  final _setBody = <String, Object?>{};

  GatherTownApiService() {
    // Get the gather.town credentials - from local file if running locally
    // or from environment variable if in Cloud Run.
    final credentialsString = Platform.environment['CREDENTIALS'] ??
        File('credentials.json').readAsStringSync();
    _credentials = json.decode(credentialsString).cast<String, String>();

    _getUri = Uri.https('gather.town', '/api/getMap', _credentials);

    // We also keep the query parameters as a member, to be combined with the
    // current gather.town map data in setMap. Here we add set the credentials.
    _setBody.addAll(_credentials);
  }

  Future<GatherTownMap> retrieveCurrentMap() async {
    // Retrieve the current gather.town map & store in the member variable
    final response = await _client.get(_getUri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    print(response);
    return json.decode(response.body);
  }

  Future<shelf.Response> setCurrent({required GatherTownMap map}) async {
    _setBody['mapContent'] = map;

    // TODO: remove if using getUri works
    // final setUri = _getUri.replace(queryParameters: _setBody);

    final response = await _client.post(_getUri,
        body: json.encode(_setBody),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});

    return shelf.Response.ok(response.body);
  }
}
