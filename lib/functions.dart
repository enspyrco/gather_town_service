import 'package:functions_framework/functions_framework.dart';
import 'package:gather_town_service/utils/locator.dart';
import 'package:shelf/shelf.dart';

// We are using a ServiceLocator to hold the services, so we can easily check
// what is already available and only create services as required.
//
// The service locator pattern is also useful for testing, particularly in a
// serverless context where we cannot use constructor injection for the
// top-level function.
//
// The locator is in the global scope so, combined with lazy loading of
// services, should give us the best of both worlds - reducing cold start times
// and improving performance on warm starts.

@CloudFunction()
Future<Response> function(Request request) async {
  try {
    // The service locator will return the service if it exists or create it.
    final mapService = await Locator.getMapServiceAsync();

    // Retrieve the delta from the query and call the corresponding function
    final delta = request.requestedUri.queryParameters['delta'] ??
        (throw 'Request must include a valid delta, params: ${request.requestedUri.queryParameters}');

    // Apply the requested change and push the new map to the gather town server
    mapService.apply(delta);
    final httpResponse = await mapService.push();

    print(httpResponse.body);
    return Response.ok(httpResponse.body);
  } catch (error, trace) {
    print('$error\n\n${trace.toString()}');
    return Response.ok('Error: $error\n\n$trace');
  }
}
