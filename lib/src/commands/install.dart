import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import '../dcli/resources/generated/resource_registry.g.dart';
import '../global_args.dart';
import '../unpubd_paths.dart';
import '../unpubd_settings.dart';
import '../util/log.dart';
import '../version/version.g.dart';
import 'config.dart';
import 'pull.dart';

///
class InstallCommand extends Command<void> {
  ///
  InstallCommand();

  @override
  String get description => 'Installs unpubd.';

  @override
  String get name => 'install';

  @override
  void run() {
    install();
  }

  ///
  void install() {
    if (!exists(UnpubdPaths().pathToSettingsDir)) {
      createDir(UnpubdPaths().pathToSettingsDir, recursive: true);
    }
    UnpubdSettings.load();

    print(orange('Installing unpubd version: $packageVersion.'));
    if (which('docker-compose').notfound) {
      printerr('Please install docker-compose');
      exit(1);
    }

    if (which('docker').notfound) {
      printerr('Please install docker');
      exit(1);
    }

    if (!exists(UnpubdPaths().pathToSettingsDir)) {
      createDir(UnpubdPaths().pathToSettingsDir, recursive: true);
    }

    ResourceRegistry.resources['Dockerfile']!
        .unpack(UnpubdPaths().pathToDockerfile);
    ResourceRegistry.resources['docker-compose.yaml']!
        .unpack(UnpubdPaths().pathToDockerCompose);

    ConfigCommand().promptForConfig();

    PullCommand.pull();

    print(blue('''
To start the unpubd server:
  - Run 'unpubd up' to start unpubd in the foreground.
  - Run 'unpubd up --detached' to start unpubd as a daemon.
'''));
    print(blue('''
To access the unpub repository use unpub or funpub in place of dart/flutter pub.
  - Use unpub for the Dart SDK
  - Use funpub for the Flutter SDK.

Alternatively you can create the PUB_HOSTED_URL environment variable and continue to use dart pub or flutter pub.
'''));

    print(green('Install of unpubd complete.'));
  }
}
