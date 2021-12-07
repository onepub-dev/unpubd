import 'package:hive/hive.dart';
import 'package:unpub/unpub.dart';

@HiveType(typeId: 2)
class Version extends HiveObject {
  Version(this.name, this.version);
  @HiveField(0)
  String name;
  @HiveField(1)
  UnpubVersion version;

  @HiveField(2)
  int downloadCount = 0;

  @override
  String toString() => '$name: $version : count: $downloadCount';
}
