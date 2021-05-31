import 'dart:convert';
import 'dart:io';

import 'package:gather_town_service/utils/typedefs.dart';
import 'package:http/http.dart' as http;

class GatherTownApiService {
  late final _client;
  late final Map<String, String> _credentials;
  late final Uri _getUri;
  final _setUri = Uri.https('gather.town', '/api/setMap');
  final _setBody = <String, Object?>{};

  GatherTownApiService([http.Client? client])
      : _client = client ?? http.Client() {
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
    return json.decode(response.body);
  }

  Future<http.Response> setCurrent({required GatherTownMap map}) async {
    // The request body needs to have the credentials (previously added) and
    // the current map.
    _setBody['mapContent'] = map;

    final response = await _client.post(_setUri,
        body: json.encode(_setBody),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});

    return response;
  }
}
