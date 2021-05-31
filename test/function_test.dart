import 'package:gather_town_service/functions.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test-doubles/mocks/dart_core.mocks.dart';
import 'test-doubles/mocks/shelf.mocks.dart';

const defaultTimeout = Timeout(Duration(seconds: 3));

void main() {
  group('The gather_town_service function', () {
    setUp(() {
      // Locator.provide(apiService: GatherTownApiService(MockClient()));
    });

    test('should create an api service if none exists', () async {
      final mockRequest = MockRequest();
      final uri = MockUri();
      when(mockRequest.requestedUri).thenReturn(uri);
      when(uri.queryParameters)
          .thenReturn(<String, String>{'delta': 'blockGame'});

      try {
        await function(mockRequest);
      } catch (error, trace) {
        print('$error\n\n${trace.toString()}');
      }
    });
  });
}

//   test('defaults', () async {
//     final proc = await TestProcess.start('dart', ['bin/server.dart']);

//     await expectLater(
//       proc.stdout,
//       emitsThrough('Listening on :8080'),
//     );

//     final response = await http.get(Uri.parse('http://localhost:8080'));
//     expect(response.statusCode, 200);
//     expect(response.body, 'Hello, World!');

//     await expectLater(
//       proc.stdout,
//       emitsThrough(endsWith('GET     [200] /')),
//     );

//     proc.signal(ProcessSignal.sigterm);
//     await proc.shouldExit(0);

//     await expectLater(
//       proc.stdout,
//       emitsThrough('Received signal SIGTERM - closing'),
//     );
//   }, timeout: defaultTimeout);
// }
