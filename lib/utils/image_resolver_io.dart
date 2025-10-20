import 'dart:io';

import 'package:flutter/material.dart';

ImageProvider? resolveUserImage(String? path) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('assets/')) {
    return AssetImage(path);
  }
  if (path.startsWith('http')) {
    return NetworkImage(path);
  }
  final file = File(path);
  if (!file.existsSync()) return null;
  return FileImage(file);
}
