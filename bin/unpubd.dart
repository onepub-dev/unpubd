#! /usr/bin/env dcli

import 'package:unpubd/src/entry_point.dart';
import 'package:unpubd/src/version/version.g.dart';

void main(List<String> arguments) {
  print('unpubd  version: $packageVersion');
  entrypoint(arguments);
}
