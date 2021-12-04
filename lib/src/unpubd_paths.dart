import 'package:dcli/dcli.dart';

class UnpubdPaths {
  factory UnpubdPaths() => _self;

  factory UnpubdPaths.forTest(String settingsRoot, String dockerRoot) =>
      _self = UnpubdPaths._internal(settingsRoot, dockerRoot);

  UnpubdPaths._internal(this._settingsRoot, this._dockerRoot);
  static UnpubdPaths _self = UnpubdPaths._internal(HOME, rootPath);

  /// Path to the .batman settings directory
  late final String pathToSettingsDir =
      env['UPUBD_PATH'] ?? join(_settingsRoot, '.unpubd');

  ///
  late final pathToDockerfile = join(pathToSettingsDir, 'Dockerfile');

  /// path within the docker container.
  late final String pathToPackages = join(_dockerRoot, 'unpub', 'packages');

  late final String pathToDockerCompose =
      join(pathToSettingsDir, 'docker-compose.yaml');

  late final String pathToDotEnv = join(pathToSettingsDir, '.env');

  /// Path in mongo docker container to
  /// mongo initdb scripts
  late final String pathToMongoEntryPoint = join(pathToSettingsDir, 'initdb.d');

  late final String pathToUserCreateJs =
      join(pathToMongoEntryPoint, 'create_user.js');
  final String _settingsRoot;
  final String _dockerRoot;
}
