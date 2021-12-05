import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import '../dcli/resource/generated/resource_registry.g.dart';
import '../unpubd_paths.dart';

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
    prepareDocker();
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

  void prepareDocker() {
    ResourceRegistry.resources['Dockerfile']!
        .unpack(UnpubdPaths().pathToDockerfile);
    ResourceRegistry.resources['docker-compose.yaml']!
        .unpack(UnpubdPaths().pathToDockerCompose);

    replace(UnpubdPaths().pathToDockerCompose, '#PATH_TO_INITDB#',
        UnpubdPaths().pathToMongoEntryPoint);

    writeUserCreate(
        username: UnpubdSettings().mongoRootUsername,
        password: UnpubdSettings().mongoRootPassword);
  }

  void writeUserCreate({required String username, required String password}) {
    if (!exists(UnpubdPaths().pathToMongoEntryPoint)) {
      createDir(UnpubdPaths().pathToMongoEntryPoint, recursive: true);
    }
    final script = '''
      db.createUser(
   {
     user: "$username",
     pwd: "$password",
     roles: [ "readWrite", "dbAdmin" ]
   }
)
''';
    UnpubdPaths().pathToUserCreateJs.write(script);
  }
}
