import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:unpub/unpub.dart';

import '../global_args.dart';
import '../unpubd_settings.dart';
import '../util/log.dart';
import 'run_args.dart';

///
class RunCommand extends Command<void> {
  ///
  RunCommand() {
    RunArgs().build(argParser);
  }

  @override
  String get description => 'Run unpub within the docker container.';

  @override
  String get name => 'run';

  @override
  void run() {
    RunArgs().parse(argResults!);

    if (!exists(UnpubdSettings.pathToSettings)) {
      logerr(red('''You must run 'unpubd install' first.'''));
      exit(1);
    }

    if (!ParsedArgs().secureMode) {
      log(orange('Warning: you are running in insecure mode. '
          'Hash files can be modified by any user.'));
    }

    waitForEx<void>(_run());
  }

  Future<void> _run() async {
    final db = await waitForMongo();

    await runUnpubd(db);
  }

  Future<Db> waitForMongo() async {
    Db? db;
    var connected = false;
    while (!connected) {
      try {
        db = Db(mongoUri());
        await db.open(); // make sure the MongoDB connection opened
        connected = true;

        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        print('waiting for mongodb to start: $e');
        sleep(2);
      }
    }

    return db!;
  }

  String mongoUri() {
    final database = env['MONGO_DATABASE'];
    return 'mongodb://mongodb:27017/$database';
  }

  String mongoRootUri() {
    final database = env['MONGO_DATABASE'];
    final rootPassword = env['MONGO_ROOT_PASSWORD'];
    return 'mongodb://root:$rootPassword@mongodb:27017/$database';
  }

  Future<void> runUnpubd(Db db) async {
    if (!exists(UnpubdSettings.pathToPackages)) {
      createDir(UnpubdSettings.pathToPackages, recursive: true);
    }
    final app = App(
      metaStore: MongoStore(db),
      packageStore: FileStore(UnpubdSettings.pathToPackages),
    );

    final unpubHost = env['UNPUBD_HOST'];
    final unpubPort = env['UNPUBD_PORT'] ?? '4000';

    final server = await app.serve(unpubHost, int.parse(unpubPort));
    print('Serving at http://${server.address.host}:${server.port}');
  }
}
