import 'package:gather_town_service/services/gather_town_api_service.dart';
import 'package:gather_town_service/services/gather_town_map_service.dart';

class Locator {
  static GatherTownApiService getApiService() => _apiService!;

  // We use the create() method which in turn uses the api service to get the
  // current map and is thus async. This strategy could probably be simplified
  // but after a few different approaches this has been deemed 'good enough'
  // for now.
  static Future<GatherTownMapService> getMapServiceAsync() async {
    if (_mapService != null) return Future.value(_mapService);
    return GatherTownMapService.create();
  }

  static void provide(
      {GatherTownApiService? apiService, GatherTownMapService? mapService}) {
    _apiService = apiService ?? _apiService;
    _mapService = mapService ?? _mapService;
  }

  static late GatherTownApiService? _apiService = GatherTownApiService();
  static GatherTownMapService? _mapService;
}
