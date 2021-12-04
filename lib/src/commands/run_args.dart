import 'dart:io';

import 'package:dcli/dcli.dart';

///
class RunArgs {
  ///
  factory RunArgs() => _self;

  RunArgs._internal();
  static final RunArgs _self = RunArgs._internal();

  ///
  late final String mongohost;

  ///
  late final String mongoport;

  ///
  late final String database;

  ///
  late final String dbuser;

  ///
  late final String? dbpassword;

  /// if true we will create the db if it doesn't exist.
  late final bool create;

  ///
  late final String? dbRootUser;

  ///
  late final String? dbRootPassword;

  ///
  late final String unpubport;

  ///
  void build(ArgParser parser) {
    parser
      ..addOption(
        'mongohost',
        help: 'mongo host',
        defaultsTo: 'localhost',
      )
      ..addOption('mongoport', help: 'mongo port', defaultsTo: '27017')
      ..addOption('database', help: 'database name')
      ..addOption('dbrootusername', help: 'db root username')
      ..addOption('dbrootpassword', help: 'db root password')
      ..addOption('dbusername', help: 'db username')
      ..addOption('dbpassword', help: 'db password')
      ..addOption('unpubport', help: 'unpub web port', defaultsTo: '4000')
      ..addFlag('create', abbr: 'c', help: '''
Creates the db if it doesn't exist.
You must pass in --dbrootusername and --dbrootpassword''');
  }

  ///
  void parse(ArgResults parsed) {
    // try {
    //   parsed = parser.parse(args);
    // } on FormatException catch (e) {
    //   printerr(red('Invalid argument: ${e.message}'));
    //   showUsage(parser);
    //   exit(1);
    // }

    mongohost =
        parsed['mongohost'] as String? ?? env['MONGO_HOST'] ?? 'localhost';
    mongoport = parsed['mongoport'] as String? ?? env['MONGO_PORT'] ?? '27017';

    database =
        parsed['database'] as String? ?? env['MONGO_DATABASE'] ?? 'unpubd';

    dbuser = parsed['dbusername'] as String? ??
        env['MONGO_ROOT_USERNAME'] ??
        'unpubd';
    dbpassword = parsed['dbpassword'] as String? ?? env['MONGO_ROOT_PASSWORD'];

    if (dbpassword == null) {
      printerr(red('You must provide password via either '
          'the command line arg --dbpassword or '
          'the environment variable MONGO_ROOT_PASSWORD'));
      exit(1);
    }
    unpubport = parsed['unpubport'] as String? ?? env['UNPUBD_PORT'] ?? '4000';

    create = parsed['create'] as bool;
    if (create) {
      dbRootUser =
          parsed['dbrootusername'] as String? ?? env['MONGO_ROOT_USERNAME'];

      if (dbRootUser == null) {
        printerr(red('You must provide dbRootUser via either '
            'the command line arg --dbrootusername or '
            'the environment variable MONGO_ROOT_USERNAME'));
        exit(1);
      }

      dbRootPassword =
          parsed['dbrootpassword'] as String? ?? env['MONGO_ROOT_PASSWORD'];

      if (dbRootPassword == null) {
        printerr(red('You must provide dbRootPassword via either '
            'the command line arg --dbrootpassword or '
            'the environment variable MONGO_ROOT_PASSWORD'));
        exit(1);
      }
    }
  }

  void showUsage(ArgParser parser) {
    print('Waits for mongo to start, Connects to mongo, '
        'and creates an initial user if required');
    print(parser.usage);
  }
}
