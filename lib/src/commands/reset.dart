import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:docker2/docker2.dart';

import 'run_args.dart';

///
class ResetCommand extends Command<void> {
  ///
  ResetCommand() {
    RunArgs().build(argParser);
  }

  @override
  String get description =>
      'Destroys the Mongo Db Volume deleting all existing packages!';

  @override
  String get name => 'reset';

  @override
  void run() {
    RunArgs().parse(argResults!);

    waitForEx<void>(_reset());
  }

  Future<void> _reset() async {
    if (!confirm('Are you sure? '
        'Proceeding will delete the Mongo DB and all existing packages!')) {
      exit(0);
    }
    final container = Docker().findContainerByName('unpubd');
    if (container == null) {
      printerr(red('Unable to find the unpubd container '
          'which should be called unpubd'));
      exit(0);
    }

    final volumes = container.volumes;
    for (final volume in volumes) {
      if (!confirm('Delete volume ${volume.name}?')) {
        volume.delete();
        print('Volume ${volume.name} deleted');
      }
    }
  }
}
