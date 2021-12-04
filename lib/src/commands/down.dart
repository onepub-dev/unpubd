import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import '../unpubd_paths.dart';
import '../unpubd_settings.dart';
import '../util/log.dart';

///
class DownCommand extends Command<void> {
  ///
  DownCommand();

  @override
  String get description => 'Stops the unpubd daemon.';

  @override
  String get name => 'down';

  @override
  void run() {
    UnpubdSettings.load();

    if (!exists(UnpubdSettings.pathToSettings)) {
      logerr(red('''You must run 'unpubd install' first.'''));
      exit(1);
    }

    down();
  }

  ///
  void down() {
    print('Stoping unpubd');
    'docker-compose down'
        .start(workingDirectory: dirname(UnpubdPaths().pathToDockerCompose));
  }
}
