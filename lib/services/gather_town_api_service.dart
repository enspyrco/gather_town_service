import 'dart:convert';
import 'dart:io';

import 'package:gather_town_service/utils/typedefs.dart';
import 'package:googleapis/secretmanager/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class GatherTownApiService {
  late final _client;
  late final Map<String, String> _credentials;
  late final Uri _getUri;
  final _setUri = Uri.https('gather.town', '/api/setMap');
  final _setBody = <String, Object?>{};

  GatherTownApiService._(Map<String, String> credentials, [http.Client? client])
      : _client = client ?? http.Client() {
    _credentials = credentials;

    _getUri = Uri.https('gather.town', '/api/getMap', _credentials);

    // We also keep the query parameters as a member, to be combined with the
    // current gather.town map data in setMap. Here we add set the credentials.
    _setBody.addAll(_credentials);
  }

  // Retrieve the gather.town api credentials from the SecretManager
  static Future<GatherTownApiService> create() async {
    final authClient = await clientViaApplicationDefaultCredentials(scopes: []);
    final secretManager = SecretManagerApi(authClient);
    final response = await secretManager.projects.secrets.versions.access(
        'projects/595692807632/secrets/gather_town_api_credentials/versions/latest');
    final credentialsString = response.payload!.data!;
    final credentials = json
        .decode(utf8.decode(base64.decode(credentialsString)))
        .cast<String, String>();
    return GatherTownApiService._(credentials);
  }

  Future<GatherTownMap> retrieveCurrentMap() async {
    // Retrieve the current gather.town map & store in the member variable
    final response = await _client.get(_getUri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    return json.decode(response.body);
  }

  Future<http.Response> pushCurrent({required GatherTownMap map}) async {
    // The request body needs to have the credentials (previously added) and
    // the current map.
    _setBody['mapContent'] = map;

    final response = await _client.post(_setUri,
        body: json.encode(_setBody),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});

    return response;
  }
}
