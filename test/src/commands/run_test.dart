import 'package:dcli/dcli.dart';
import 'package:test/test.dart';
import 'package:unpubd/src/entry_point.dart';
import 'package:unpubd/src/unpubd_paths.dart';
import 'package:unpubd/src/unpubd_settings.dart';

void main() {
  test('run ...', () async {
    env['MONGO_HOST'] = 'localhost';
    env['MONGO_PORT'] = '27017';
    env['MONGO_ROOT_USERNAME'] = 'root';
    env['MONGO_ROOT_PASSWORD'] = 'aXGONtjGrgmAZLm';
    env['MONGO_DATABASE'] = 'unpubd';

    withTempDir((dir) {
      UnpubdPaths.forTest(dir, dir);
      entrypoint(['run']);
    });
  });

  test('connect', () async {
    withTempDir((dir) {
      UnpubdPaths.forTest(dir, dir);
      UnpubdSettings.load();
      env['MONGO_HOST'] = UnpubdSettings().mongoHost;
      env['MONGO_PORT'] = UnpubdSettings().mongoPort;
      env['MONGO_ROOT_USERNAME'] = UnpubdSettings().mongoRootUsername;
      env['MONGO_ROOT_PASSWORD'] = UnpubdSettings().mongoRootPassword;
      env['MONGO_DATABASE'] = UnpubdSettings().mongoDatabase;

      entrypoint(['run']);
    });
  });
}
