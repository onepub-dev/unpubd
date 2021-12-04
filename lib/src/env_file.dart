import 'package:dcli/dcli.dart';

import 'unpubd_paths.dart';
import 'unpubd_settings.dart';

// ignore: avoid_classes_with_only_static_members
class EnvFile {
  static void create() {
    /// Create the .env for docker-compose to get its environment from.
    UnpubdPaths().pathToDotEnv
      ..write('MONGO_INITDB_ROOT_USERNAME=root')
      ..append(
          'MONGO_INITDB_ROOT_PASSWORD=${UnpubdSettings().mongoRootPassword}')
      ..append('MONGO_INITDB_DATABASE=${UnpubdSettings().mongoDatabase}')
      ..append('MONGO_DATABASE=${UnpubdSettings().mongoDatabase}')
      ..append('MONGO_ROOT_USERNAME=root')
      ..append('MONGO_ROOT_PASSWORD=${UnpubdSettings().mongoRootPassword}')
      ..append('MONGO_DATABASE=${UnpubdSettings().mongoDatabase}')
      ..append('MONGO_HOST=mongodb')
      ..append('MONGO_PORT=27017')
      ..append('TZ=${DateTime.now().timeZoneName}')
      ..append('UNPUBD_HOST=${UnpubdSettings().unpubHost}')
      ..append('UNPUBD_PORT=${UnpubdSettings().unpubPort}');
  }
}
