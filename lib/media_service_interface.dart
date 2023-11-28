// media_service_interface.dart
import 'dart:io';
import 'package:flutter/cupertino.dart';

enum AppImageSource {
  camera,
  gallery,
}

abstract class MediaServiceInterface {
  Future<File?> uploadImage(
    BuildContext context,
    AppImageSource appImageSource, {
    bool shouldCompress = true,
  });

  Future<File?> compressFile(File file, {int quality = 30});
}
