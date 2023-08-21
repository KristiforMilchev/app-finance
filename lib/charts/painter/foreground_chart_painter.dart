// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class ForegroundChartPainter extends CustomPainter {
  final Size? size;
  final Color color;
  final Color lineColor;
  final Color areaColor;
  final Color background;
  final double yMin;
  final double yMax;
  final List<double> yArea;
  final Type xType;
  final Type yType;
  final dynamic xMin;
  final dynamic xMax;
  final List<dynamic> yMap;
  late final double textArea;
  late final double shift;
  late final int yDiv;
  final int yDivider;
  late final int xDiv;
  final int xDivider;
  final intl.DateFormat? xTpl;

  ForegroundChartPainter({
    this.areaColor = Colors.green,
    this.color = Colors.black,
    this.lineColor = Colors.black,
    this.background = Colors.grey,
    this.yMin = 0.0,
    this.yMax = 1.0,
    this.yArea = const [],
    this.yMap = const [],
    this.xType = double,
    this.yType = double,
    this.xMin = 0.0,
    this.xMax = 1.0,
    this.size,
    this.yDivider = 12,
    this.xDivider = 12,
    this.xTpl,
  }) {
    _setTextArea();
    shift = textArea * 1.2;
    yDiv = yDivider * size!.height ~/ 400;
    xDiv = xDivider * size!.width ~/ 640;
  }

  void _setTextArea() {
    double tmp = size!.width / 20;
    if (tmp > 32) {
      textArea = 32.0;
    } else if (tmp < 20) {
      textArea = 20.0;
    } else {
      textArea = tmp;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    size = this.size ?? size;
    _paintAxisY(canvas, size);
    _paintAxisX(canvas, size);
    if (yArea.length == 2) {
      _plotAssert(canvas, size);
    }
  }

  void _plotAssert(Canvas canvas, Size size) {
    final line = Paint()
      ..color = areaColor
      ..strokeWidth = 1;
    double y = _shiftStep(size.height, textArea, yDiv, ((yArea[0] + yArea[1]) / 2 - yMin) / (yMax / yDiv));
    canvas.drawLine(Offset(shift, y), Offset(size.width, y), line);
    final background = Paint()
      ..color = areaColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromPoints(
        Offset(shift, _shiftStep(size.height, textArea, yDiv, ((yArea[0] - yMin) / (yMax / yDiv)).round())),
        Offset(size.width, _shiftStep(size.height, textArea, yDiv, ((yArea[1] - yMin) / (yMax / yDiv)).round())),
      ),
      background,
    );
  }

  void _paintText(Canvas canvas, double x, double y, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: textArea / 2.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width, y));
  }

  void _paintIcon(Canvas canvas, double x, double y, IconData? icon) {
    if (icon == null) {
      return;
    }
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          color: color,
          fontSize: textArea,
          fontFamily: Icons.question_mark.fontFamily,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width, y));
  }

  void _paintAxisY(Canvas canvas, Size size) {
    final lineColor = Paint()
      ..color = this.lineColor.withOpacity(0.4)
      ..strokeWidth = 0.5;
    double step = (yMax - yMin) / yDiv;
    for (int i = 0; i < yDiv; i++) {
      double delta = step * i;
      double y = _shiftStep(size.height, textArea, yDiv, i);
      canvas.drawLine(Offset(shift, y), Offset(size.width, y), lineColor);
      if (yType == double) {
        _paintText(canvas, textArea, y - textArea / 3, (yMin + delta).toStringAsFixed(2));
      } else if (yType == IconData) {
        final code = yDiv - i - 1 >= yMap.length ? null : yMap[yDiv - i - 1];
        _paintIcon(canvas, textArea, y - textArea, code);
      }
    }
  }

  double _shiftStep(total, shift, div, i) {
    return (total - shift) * (1 - i / div);
  }

  void _paintAxisX(Canvas canvas, Size size) {
    final lineColor = Paint()
      ..color = this.lineColor.withOpacity(0.4)
      ..strokeWidth = 0.5;
    final background = Paint()
      ..color = this.background.withOpacity(0.05)
      ..style = PaintingStyle.fill;
    double? step;
    double? min;
    if (xType == DateTime) {
      min = xMin.millisecondsSinceEpoch * 1.0;
      step = (xMax.millisecondsSinceEpoch - min - 1) / xDiv;
    } else {
      min = xMin;
      step = (xMax - xMin) / xDiv;
    }
    double height = size.height - textArea;
    for (int i = 0; i <= xDiv; i++) {
      double delta = step! * (xDiv - i);
      double x = _shiftStep(size.width, shift, xDiv, i);
      canvas.drawLine(Offset(x + shift, height), Offset(x + shift, height + 4), lineColor);
      if (i < xDiv) {
        dynamic value = min! + delta;
        if (xType == DateTime) {
          DateTime tmp = DateTime.fromMillisecondsSinceEpoch((min + delta).toInt());
          if (xTpl != null) {
            value = xTpl!.format(tmp);
          } else {
            value = intl.DateFormat('d').format(tmp);
          }
        }
        _paintText(canvas, x + shift - 2, height + 1, value.toString());
      }
      if (i % 2 != 0) {
        canvas.drawRect(
          Rect.fromPoints(
            Offset(x + shift, 0),
            Offset(_shiftStep(size.width, shift, xDiv, i - 1) + shift, height),
          ),
          background,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
