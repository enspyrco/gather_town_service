import 'package:gather_town_service/functions.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test-doubles/dart_core.mocks.dart';
import 'test-doubles/shelf.mocks.dart';

const defaultTimeout = Timeout(Duration(seconds: 3));

void main() {
  group('gather_town_service function', () {
    test('creates an api service if none exists', () {
      final request = MockRequest();
      final uri = MockUri();
      when(request.requestedUri).thenReturn(uri);
      when(uri.queryParameters)
          .thenReturn(<String, String>{'delta': 'showGame'});

      function(request);
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
