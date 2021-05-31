import 'package:gather_town_service/gather_town_api_service.dart';

class Locator {
  static GatherTownApiService getApiService() {
    return _apiService!;
  }

  static void provide(GatherTownApiService apiService) {
    _apiService = apiService;
  }

  static GatherTownApiService? _apiService = GatherTownApiService();
}
