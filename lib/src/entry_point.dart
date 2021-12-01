#! /usr/bin/env dcli

import 'package:unpubd/src/unpubd_settings.dart';

import 'global_args.dart';

void entrypoint(List<String> args) {
  UnpubdSettings.load();
  ParsedArgs.withArgs(args).run();
}
