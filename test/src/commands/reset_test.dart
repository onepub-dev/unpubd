import 'package:test/test.dart';
import 'package:unpubd/src/commands/reset.dart';

void main() {
  test('reset ', () async {
    ResetCommand().run();
  });
}
