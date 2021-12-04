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
    UnpubdSettings.load();

    if (!exists(UnpubdSettings.pathToSettings)) {
      logerr(red('''You must run 'unpubd install' first.'''));
      exit(1);
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
    // final mongoUsername = ask('Mongo Username:',
    //     validator: Ask.alphaNumeric,
    //     defaultValue: UnpubdSettings().mongoUsername);

    // String? mongoPassword;
    // String? confirmPassword;

    // do {
    //   mongoPassword = ask('Mongo Password:',
    //       hidden: true,
    //       validator: Ask.all([Ask.alphaNumeric, Ask.lengthMin(10)]),
    //       defaultValue: UnpubdSettings().mongoPassword);
    //   confirmPassword = ask('Confirm Mongo Password:',
    //       hidden: true,
    //       validator: Ask.all([Ask.alphaNumeric, Ask.lengthMin(10)]),
    //       defaultValue: UnpubdSettings().mongoPassword);
    // } while (mongoPassword != confirmPassword);

    UnpubdSettings().mongoRootUsername = 'root';
    UnpubdSettings().mongoRootPassword = generateRandomString(15);
    UnpubdSettings().unpubPort = port;
    UnpubdSettings().save();
  }
}
