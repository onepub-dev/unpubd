#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:unpubd/src/version/version.g.dart';

/// build and publish the unpubd docker container.
void main(List<String> args) {
  final parser = ArgParser()
    ..addFlag('clean',
        abbr: 'c', help: 'Force a full rebuild of the docker container')
    ..addFlag('clone', abbr: 'l', help: 'Force reclone of the git repo.');

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

  'dcli pack'.run;

  print(blue('Building unpubd $packageVersion'));

  final tag = 'noojee/unpubd:$packageVersion';
  const latest = 'noojee/unpubd:latest';

  var clean = '';
  if (parsed['clean'] as bool == true) {
    clean = ' --no-cache';
  }

  if (parsed['clone'] as bool == true) {
    final uuid = const Uuid().v4().replaceAll('-', '');
    replace(dockerfilePath, RegExp('RUN mkdir -p /BUILD_TOKEN/.*'),
        'RUN mkdir -p /BUILD_TOKEN/$uuid');
  }

  'docker  build $clean -t $tag -t $latest -f $dockerfilePath .'.run;

  'docker push $tag'.run;
  'docker push $latest'.run;
}
