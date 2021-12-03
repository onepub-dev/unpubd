import 'package:dcli/dcli.dart';
import 'package:test/test.dart';
import 'package:unpubd/src/entry_point.dart';
import 'package:unpubd/src/unpubd_paths.dart';

void main() {
  test('run ...', () async {
    env['MONGO_HOST'] = 'localhost';
    env['MONGO_PORT'] = '27017';
    env['MONGO_ROOT_USERNAME'] = 'root';
    env['MONGO_ROOT_PASSWORD'] = '50dqSGKIvZkcFWA';
    env['MONGO_DATABASE'] = 'unpubd';
    env['MONGO_USERNAME'] = 'test_username';
    env['MONGO_PASSWORD'] = 'test_password';

    withTempDir((dir) {
      UnpubdPaths.forTest(dir, dir);
      entrypoint(['run', '--create']);
    });
  });
}
