import 'package:test/test.dart';
import 'package:unpubd/src/commands/reset.dart';

void main() {
  test('reset delete Mongo container', () async {
    ResetCommand().deleteMongoContainer();
  });


  test('reset delete volume', () async {
    ResetCommand().deleteMongoContainer();
  });}
