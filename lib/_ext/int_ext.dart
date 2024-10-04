// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';

extension IntExt on int {
  static final Map<String, IconData> _cache = {};

  IconData toIcon() {
    if (_cache.containsKey(this)) {
      return _cache[this]!;
    } else {
      const String fontFamily = 'MaterialIcons';
      return IconData(this, fontFamily: fontFamily);
    }
  }

  String toByteSize() {
    const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
    if (this == 0) return '0 B';
    final i = (log(this) / log(1024)).floor();
    return '${(this / pow(1024, i)).toStringAsFixed(2)} ${sizes[i]}';
  }
}
