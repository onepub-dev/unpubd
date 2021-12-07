import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Uploader extends HiveObject {
  Uploader(this.name, this.email);
  @HiveField(0)
  String name;
  @HiveField(1)
  String email;

  @override
  String toString() => '$name: $email';
}
