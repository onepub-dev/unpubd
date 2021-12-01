import 'package:dcli/dcli.dart';
import 'package:test/test.dart';
import 'package:unpubd/src/entry_point.dart';

void main() {
  test('run ...', () async {
    env['MONGO_ROOT_USERNAME'] = 'root';
    env['MONGO_ROOT_PASSWORD'] = 'testrootpassword';
    env['MONGO_DATABASE'] = 'test_dart_pub';
    env['MONGO_USERNAME'] = 'test_username';
    env['MONGO_PASSWORD'] = 'test_password';
    entrypoint(['run', '--create']);
  });
}
