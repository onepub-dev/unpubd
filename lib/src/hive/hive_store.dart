import 'package:hive/hive.dart';
import 'package:unpub/unpub.dart';

import 'boxes.dart';
import 'model/package.dart';
import 'model/uploader.dart';
import 'model/version.dart';

class HiveStore implements MetaStore {
  @override
  Future<void> addUploader(String name, String email) async {
    final uploader = Uploader(name, email);

    final uploaders = await Boxes().uploaders;
    await uploaders.put(email, uploader);
  }

  @override
  Future<void> addVersion(String name, UnpubVersion version) async {
    final packages = await Boxes().packages;

    final package = await packages.get(name);

    if (package == null) {
      package = Package(name);
    }

    final _version = Version(name, version);

    /// TODO how do we store multiple versions?
    final versions = await Boxes().versions;
    await versions.put(name, _version);
  }

  @override
  void increaseDownloads(String name, String version) async {
    final versions = await Boxes().versions;

    final _version = versions.get(name) as Version;
    _version.downloadCount++;
    await _version.save();
  }

  @override
  Future<UnpubPackage?> queryPackage(String name) {
    // TODO: implement queryPackage
    throw UnimplementedError();
  }

  @override
  Future<UnpubQueryResult> queryPackages(
      {required int size,
      required int page,
      required String sort,
      String? keyword,
      String? uploader,
      String? dependency}) {
    // TODO: implement queryPackages
    throw UnimplementedError();
  }

  @override
  Future<void> removeUploader(String name, String email) async {
    final uploaders = await Boxes().uploaders;
    final uploader = await uploaders.get(email);
    if (uploader != null) {
      await uploader.delete();
    }
  }
}
