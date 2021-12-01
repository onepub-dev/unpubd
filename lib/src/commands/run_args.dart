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
  late final String dbpassword;

  ///
  late final String unpubport;

  ///
  void build(ArgParser parser) {
    parser
      ..addOption('mongohost',
          help: 'mongo host', defaultsTo: 'localhost', mandatory: true)
      ..addOption('mongoport',
          help: 'mongo port', defaultsTo: '27017', mandatory: true)
      ..addOption('database', help: 'database name', mandatory: true)
      ..addOption('dbuser', help: 'db username', mandatory: true)
      ..addOption('dbpassword', help: 'db password', mandatory: true)
      ..addOption('unpubport',
          help: 'unpub web port', defaultsTo: '4000', mandatory: true);
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

    mongohost = parsed['mongohost'] as String;
    mongoport = parsed['mongoport'] as String;
    database = parsed['database'] as String;
    dbuser = parsed['dbuser'] as String;
    dbpassword = parsed['dbpassword'] as String;

    unpubport = parsed['unpubport'] as String;
  }

  void showUsage(ArgParser parser) {
    print('Waits for mongo to start, Connects to mongo, '
        'and creates an initial user if required');
    print(parser.usage);
  }
}
