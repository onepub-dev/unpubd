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
    print(
        red('Proceeding will delete the Mongo DB and all existing packages!'));
    if (!confirm(red('Are you sure? '))) {
      exit(0);
    }

    final mongoVolumes = deleteContainer('mongo');
    final unpudVolumes = deleteContainer('unpubd');

    /// container so delete volume by name.
    final volume = Volumes().findByName('unpubd_mongodata');
    if (volume != null) {
      volume.delete();
      print('Volume ${volume.name} deleted');
    }

    /// incase there were any other volumes attached
    /// lets delete them too.
    deleteVolumes(mongoVolumes);
    deleteVolumes(unpudVolumes);
  }

  void deleteVolumes(List<Volume> volumes) {
    for (final volume in volumes) {
      if (!confirm('Delete volume ${volume.name}?')) {
        volume.delete();
        print('Volume ${volume.name} deleted');
      }
    }
  }

  List<Volume> deleteContainer(String name) {
    final container = Docker().findContainerByName(name);
    var volumes = <Volume>[];
    if (container != null) {
      volumes = container.volumes;
      print('Stopping $name');
      container.stop();
      while (container.isRunning) {
        sleep(5);
        echo('.');
      }
      print('Deleting $name');
      container.delete();
    }
    return volumes;
  }
}
