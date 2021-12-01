import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import '../global_args.dart';
import '../unpubd_settings.dart';
import '../util/log.dart';

///
class ConfigCommand extends Command<void> {
  ///
  ConfigCommand();

  @override
  String get description => 'Configures unpubd.';

  @override
  String get name => 'config';

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
  void config() {
    print('Configure UnpubD');
    promptForConfig();
  }

  void promptForConfig() {
    final port = ask('unpubd port:',
        validator: Ask.integer, defaultValue: UnpubdSettings().unpubPort);
    final mongoUsername = ask('Mongo Username:',
        validator: Ask.alphaNumeric,
        defaultValue: UnpubdSettings().mongoUsername);

    var mongoPassword = 'a';
    var confirmPassword = 'b';

    while (mongoPassword != confirmPassword) {
      mongoPassword = ask('Mongo Password:',
          hidden: true,
          validator: Ask.all([Ask.alphaNumeric, Ask.lengthMin(10)]),
          defaultValue: UnpubdSettings().mongoPassword);
      confirmPassword = ask('Confirm Mongo Password:',
          hidden: true,
          validator: Ask.all([Ask.alphaNumeric, Ask.lengthMin(10)]),
          defaultValue: UnpubdSettings().mongoPassword);
    }

    UnpubdSettings().unpubPort = port;
    UnpubdSettings().mongoUsername = mongoUsername;
    UnpubdSettings().mongoPassword = mongoPassword;
    UnpubdSettings().save();
  }
}
