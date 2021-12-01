import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import '../global_args.dart';
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
    if (!exists(UnpubdSettings.pathToSettings)) {
      logerr(red('''You must run 'unpubd install' first.'''));
      exit(1);
    }

    if (!ParsedArgs().secureMode) {
      log(orange('Warning: you are running in insecure mode. '
          'Hash files can be modified by any user.'));
    }

    config();
  }

  ///
  void config() {}
}
