#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';
import 'package:dcli/src/version/version.g.dart';
import 'package:unpubd/src/unpubd_settings.dart';

/// build and publish the unpubd docker container.
void main(List<String> args) {
  final dockerfilePath =
      join(DartProject.self.pathToProjectRoot, 'resources', 'Dockerfile');

  const tag = 'noojee/unpubd:1.0.0';
  const latest = 'noojee/unpubd:latest';

  'docker  build -t $tag -t $latest -f $dockerfilePath .'.run;
  'docker push noojee/unpub:$packageVersion'.run;
  'docker push $tag'.run;
  'docker push $latest'.run;
}
