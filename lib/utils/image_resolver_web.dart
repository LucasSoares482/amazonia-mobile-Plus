import 'package:flutter/material.dart';

ImageProvider? resolveUserImage(String? path) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('assets/')) {
    return AssetImage(path);
  }
  if (path.startsWith('http') ||
      path.startsWith('blob:') ||
      path.startsWith('data:')) {
    return NetworkImage(path);
  }
  return null;
}
