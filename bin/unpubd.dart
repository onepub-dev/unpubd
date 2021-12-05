#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';
import 'package:unpubd/src/entry_point.dart';
import 'package:unpubd/src/version/version.g.dart';

void main(List<String> arguments) {
  print(green('unpubd version: $packageVersion'));
  entrypoint(arguments);
}
