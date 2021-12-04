#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:unpubd/src/unpubd_settings.dart';

void main(List<String> arguments) {

    UnpubdSettings.load();
    if (!exists(UnpubdSettings.pathToSettings)) {
      logerr(red('''You must run 'unpubd install' first.'''));
      exit(1);
    }
    
  env['PUB_HOSTED_URL'] = 'http://localhost:${UnpubdSettings().unpubPort}';
  DartSdk().runPub(args: arguments);

  final progress = Progress.print();
  startFromArgs(
    'flutter',
    ['pub', ...arguments],
    nothrow: true,
    progress: progress,
  );
}

void logerr(String red) {
}
