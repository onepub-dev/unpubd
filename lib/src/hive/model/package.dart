import 'package:hive/hive.dart';
import 'package:unpub/unpub.dart';

import 'version.dart';

@HiveType(typeId: 2)
class Package extends HiveObject {
  Package(this.name);
  @HiveField(0)
  String name;

  @HiveField(1)
  HiveList versions = HiveList<Version>();

  @override
  String toString() => '$name: ${versions.length}';
}
