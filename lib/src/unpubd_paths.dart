import 'package:dcli/dcli.dart';

class UnpubdPaths {
  factory UnpubdPaths() => _self;

  factory UnpubdPaths.forTest(String settingsRoot, String dockerRoot) =>
      _self = UnpubdPaths._internal(settingsRoot, dockerRoot);

  UnpubdPaths._internal(this._settingsRoot, this._dockerRoot);
  static UnpubdPaths _self = UnpubdPaths._internal(rootPath, rootPath);

  /// Path to the .batman settings directory
  late final String pathToSettingsDir =
      join(_settingsRoot, 'home', Shell.current.loggedInUser, '.unpubd');

  ///
  late final pathToDockerfile = join(pathToSettingsDir, 'Dockerfile');

  /// path within the docker container.
  late final String pathToPackages = join(_dockerRoot, 'unpub', 'packages');

  late final String pathToDockerCompose =
      join(pathToSettingsDir, 'docker-compose.yaml');

  late final String pathToDotEnv = join(pathToSettingsDir, '.env');

  final String _settingsRoot;
  final String _dockerRoot;
}
