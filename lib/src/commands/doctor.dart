import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:docker2/docker2.dart';
import '../unpubd_settings.dart';

///
class DoctorCommand extends Command<void> {
  ///
  DoctorCommand();

  @override
  String get description => 'Displays the unpubd settings';

  @override
  String get name => 'doctor';

  @override
  void run() {
    UnpubdSettings.load();
    showContainerStatus('unpubd', 'noojee/unpubd:latest');
    showContainerStatus('mongo', 'mongo:latest');

    print('Connect to the unpubd web interface via: '
        '${blue(UnpubdSettings().unpubUrl)}');

    if (Env().exists(UnpubdSettings.pubHostedUrlKey)) {
      print('${UnpubdSettings.pubHostedUrlKey}='
          '${env[UnpubdSettings.pubHostedUrlKey]}');
    } else {
      print(orange(
          'Environment variable ${UnpubdSettings.pubHostedUrlKey} not found!'));
    }
  }

  void showContainerStatus(String containerName, String imageName) {
    final container = Containers().findByName(containerName);
    if (container != null) {
      print('$containerName status: '
          '${container.isRunning ? 'running' : 'stopped'}');
    } else {
      final image = Images().findByName(imageName);
      if (image == null) {
        print('$containerName status: not installed');
      } else {
        print('$containerName status: down');
      }
    }
  }
}
