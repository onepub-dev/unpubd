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
    if (!confirm(red('Are you sure? '
        'Proceeding will delete the Mongo DB and all existing packages!'))) {
      exit(0);
    }
    final container = Docker().findContainerByName('mongo');
    if (container == null) {
      /// container so delete volume by name.
      final volume = Volumes().findByName('unpubd_mongodata');
      if (volume != null) {
        volume.delete();
        print('Volume ${volume.name} deleted');
      }
    } else {
      //  we have a container so delete attahed volumes.
      final volumes = container.volumes;
      for (final volume in volumes) {
        if (!confirm('Delete volume ${volume.name}?')) {
          deleteMongoContainer();
          volume.delete();
          print('Volume ${volume.name} deleted');
        }
      }
    }
  }

  void deleteMongoContainer() {
    final container = Docker().findContainerByName('mongo');
    if (container != null) {
      if (container.isRunning) {
        print('Stopping Mongo');
        container.stop();
      }
      print('Deleting Mongo container');
      container.delete();
    }
  }
}
