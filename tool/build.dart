#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:dcli/src/version/version.g.dart';

/// build and publish the unpubd docker container.
void main(List<String> args) {
  final parser = ArgParser()
    ..addFlag('clean',
        abbr: 'c', help: 'Force a full rebuild of the docker container');

  ArgResults parsed;
  try {
    parsed = parser.parse(args);
  } on FormatException catch (e) {
    print(e);
    print(parser.usage);
    exit(1);
  }
  final dockerfilePath =
      join(DartProject.self.pathToProjectRoot, 'resources', 'Dockerfile');

  final tag = 'noojee/unpubd:$packageVersion';
  const latest = 'noojee/unpubd:latest';

  var clean = '';
  if (parsed['clean'] as bool == true) {
    clean = ' --no-cache';
  }
  'docker  build $clean -t $tag -t $latest -f $dockerfilePath .'.run;

  'docker push noojee/unpubd:$packageVersion'.run;
  'docker push $tag'.run;
  'docker push $latest'.run;
}
