import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import '../dcli/resources/generated/resource_registry.g.dart';
import '../global_args.dart';
import '../unpubd_settings.dart';
import '../util/log.dart';
import '../version/version.g.dart';
import 'config.dart';

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
    if (!ParsedArgs().secureMode) {
      log(orange('Warning: you are running in insecure mode. '
          'Hash files can be modified by any user.'));
    }

    install();
  }

  ///
  void install() {
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

    if (!exists(UnpubdSettings.pathToSettingsDir)) {
      createDir(UnpubdSettings.pathToSettingsDir, recursive: true);
    }

    ResourceRegistry.resources['Dockerfile']!
        .unpack(UnpubdSettings.pathToDockerfile);
    ResourceRegistry.resources['docker-compose.yaml']!
        .unpack(UnpubdSettings.pathToDockerCompose);

    ConfigCommand().promptForConfig();

    print(blue("Run 'unpubd up' to start the daemon."));
    print(green('Install of unpubd complete.'));
  }
}
