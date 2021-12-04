import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import 'commands/config.dart';
import 'commands/down.dart';
import 'commands/install.dart';
import 'commands/pull.dart';
import 'commands/reset.dart';
import 'commands/run.dart';
import 'commands/up.dart';
import 'util/log.dart';
import 'version/version.g.dart';

///
class ParsedArgs {
  ///
  factory ParsedArgs() => _self;

  ///
  ParsedArgs.withArgs(this.args) : runner = CommandRunner<void>('upubd', '''

${orange('Unpub Daemon - a docker container for run unpub')}

You can alter the config by running 'unpubd config' or by modifying ~/.unpubd/unpubd.yaml''') {
    _self = this;
    build();
    parse();
  }

  static late ParsedArgs _self;

  List<String> args;
  CommandRunner<void> runner;

  late final bool colour;
  late final bool quiet;
  late final bool secureMode;
  late final bool useLogfile;
  late final String logfile;

  void build() {
    runner.argParser.addFlag('debug', help: 'Enable versbose logging');
    runner.argParser.addFlag('colour',
        abbr: 'c',
        defaultsTo: true,
        help: 'Enabled colour coding of messages. You should disable colour '
            'when using the console to log.');
    runner.argParser.addOption('logfile',
        abbr: 'l', help: 'If set all output is sent to the provided logifile');
    runner.argParser.addFlag('quiet',
        abbr: 'q',
        help: "Don't output each directory scanned just "
            'log the totals and errors.');

    runner.argParser
        .addFlag('version', help: 'Displays the unpubd version no. and exits.');

    runner
      ..addCommand(ConfigCommand())
      ..addCommand(UpCommand())
      ..addCommand(DownCommand())
      ..addCommand(InstallCommand())
      ..addCommand(PullCommand())
      ..addCommand(ResetCommand())
      ..addCommand(RunCommand());
  }

  void parse() {
    final results = runner.argParser.parse(args);
    Settings().setVerbose(enabled: results['debug'] as bool);

    final version = results['version'] as bool == true;
    if (version == true) {
      print('unpubd $packageVersion');
      exit(0);
    }

    quiet = results['quiet'] as bool == true;
    colour = results['colour'] as bool == true;

    if (results.wasParsed('logfile')) {
      useLogfile = true;
      logfile = results['logfile'] as String;
    } else {
      useLogfile = false;
    }
  }

  void showUsage() {
    runner.printUsage();
    exit(1);
  }

  void run() {
    try {
      waitForEx(runner.run(args));
    } on FormatException catch (e) {
      logerr(red(e.message));
      showUsage();
    } on UsageException catch (e) {
      logerr(red(e.message));
      showUsage();
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      logerr(red(e.toString()));
    }
  }
}
