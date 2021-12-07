import 'package:hive/hive.dart';

import 'model/package.dart';
import 'model/uploader.dart';
import 'model/version.dart';

class Boxes {
  factory Boxes() => _self;
  Boxes._internal();
  static late final Boxes _self = Boxes._internal();

  late final LazyBox<Uploader>? _uploader;
  final _uploaderKey = 'uploaders';
  Future<LazyBox<Uploader>> get uploaders async =>
      _uploader ??= await Hive.openLazyBox<Uploader>(_uploaderKey);

  late final LazyBox<Version>? _version;
  final _versionKey = 'versions';
  Future<LazyBox<Version>> get versions async =>
      _version ??= await Hive.openLazyBox<Version>(_versionKey);

  late final LazyBox<Package>? _package;
  final _packageKey = 'versions';
  Future<LazyBox<Package>> get packages async =>
      _package ??= await Hive.openLazyBox<Package>(_packageKey);
}
