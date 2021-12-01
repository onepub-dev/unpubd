import 'package:dcli/dcli.dart';
import '../global_args.dart';

void log(String message) {
  message = Ansi.strip(message);
  _logout(green(message));
}

void loginfo(String message) {
  message = Ansi.strip(message);
  _logout(blue(message));
}

void logwarn(String message) {
  message = Ansi.strip(message);
  _logerr(orange(message));
}

void logerr(String message) {
  message = Ansi.strip(message);
  _logerr(red(message));
}

void _logout(String message) {
  final args = ParsedArgs();

  if (args.colour == false) {
    message = Ansi.strip(message);
  }

  if (args.useLogfile) {
    args.logfile.append(message);
  } else {
    print(message);
  }
}

void _logerr(String message) {
  final args = ParsedArgs();

  if (args.colour == false) {
    message = Ansi.strip(message);
  }

  if (args.useLogfile) {
    args.logfile.append(message);
  } else {
    printerr(message);
  }
}

void overwriteLine(String message) {
  final args = ParsedArgs();
  if (!args.quiet) {
    if (args.useLogfile) {
      log(message);
    } else {
      Terminal().overwriteLine(message);
    }
  }
}
