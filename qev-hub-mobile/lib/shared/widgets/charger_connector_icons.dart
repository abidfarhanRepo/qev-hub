import 'package:flutter/material.dart';

/// Custom SVG icons for EV charger connector types
class ChargerConnectorIcons {
  static Widget type2({double size = 24, Color color = Colors.white}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _Type2IconPainter(color),
    );
  }

  static Widget ccs({double size = 24, Color color = Colors.white}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CCSIconPainter(color),
    );
  }

  static Widget chademo({double size = 24, Color color = Colors.white}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CHAdeMOIconPainter(color),
    );
  }

  static Widget tesla({double size = 24, Color color = Colors.white}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TeslaIconPainter(color),
    );
  }

  static Widget getIconForType(String? type, {double size = 24, Color color = Colors.white}) {
    switch (type?.toLowerCase()) {
      case 'type 2':
      case 'type2':
        return type2(size: size, color: color);
      case 'ccs':
      case 'ccs2':
        return ccs(size: size, color: color);
      case 'chademo':
        return chademo(size: size, color: color);
      case 'tesla':
      case 'nacs':
        return tesla(size: size, color: color);
      default:
        return Icon(Icons.ev_station, size: size, color: color);
    }
  }
}

/// Type 2 connector icon painter
class _Type2IconPainter extends CustomPainter {
  final Color color;

  _Type2IconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;

    // Outer circle
    canvas.drawCircle(center, radius, paint);

    // Inner details - Type 2 connector shape
    final fillPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.6, fillPaint);

    // Center dot
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.2, dotPaint);

    // Connector pins (3 pins in Type 2)
    final pinPaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final pinRadius = radius * 0.15;
    final pinOffset = radius * 0.4;

    // Top pin
    canvas.drawCircle(
      Offset(center.dx, center.dy - pinOffset),
      pinRadius,
      pinPaint,
    );

    // Bottom-left pin
    canvas.drawCircle(
      Offset(center.dx - pinOffset * 0.866, center.dy + pinOffset * 0.5),
      pinRadius,
      pinPaint,
    );

    // Bottom-right pin
    canvas.drawCircle(
      Offset(center.dx + pinOffset * 0.866, center.dy + pinOffset * 0.5),
      pinRadius,
      pinPaint,
    );
  }

  @override
  bool shouldRepaint(_Type2IconPainter oldDelegate) => color != oldDelegate.color;
}

/// CCS (Combined Charging System) icon painter
class _CCSIconPainter extends CustomPainter {
  final Color color;

  _CCSIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;

    // Type 2 top section (circle)
    canvas.drawCircle(Offset(center.dx, center.dy - radius * 0.3), radius * 0.5, paint);
    canvas.drawCircle(Offset(center.dx, center.dy - radius * 0.3), radius * 0.35, fillPaint);

    // DC pins section (rectangular at bottom)
    final dcRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.4),
        width: radius * 0.8,
        height: radius * 0.5,
      ),
      Radius.circular(radius * 0.1),
    );

    canvas.drawRRect(dcRect, paint);
    canvas.drawRRect(dcRect, fillPaint);

    // DC pins (2 pins)
    final pinPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final pinSize = radius * 0.12;
    final pinSpacing = radius * 0.2;

    // Left DC pin
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx - pinSpacing / 2, center.dy + radius * 0.4),
        width: pinSize,
        height: pinSize * 1.5,
      ),
      pinPaint,
    );

    // Right DC pin
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx + pinSpacing / 2, center.dy + radius * 0.4),
        width: pinSize,
        height: pinSize * 1.5,
      ),
      pinPaint,
    );
  }

  @override
  bool shouldRepaint(_CCSIconPainter oldDelegate) => color != oldDelegate.color;
}

/// CHAdeMO connector icon painter
class _CHAdeMOIconPainter extends CustomPainter {
  final Color color;

  _CHAdeMOIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Large circular connector
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius * 0.8, fillPaint);

    // Center depression
    final centerPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.4, centerPaint);

    // CHAdeMO signature - distinctive ring pattern
    final ringPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, radius * 0.6, ringPaint);

    // Clasp (locking mechanism)
    final claspPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final claspRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - radius * 0.7),
      width: radius * 0.4,
      height: radius * 0.15,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(claspRect, Radius.circular(radius * 0.05)),
      claspPaint,
    );

    // Two contact pins
    final pinPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final pinRadius = radius * 0.1;
    final pinY = center.dy + radius * 0.2;

    // Left pin
    canvas.drawCircle(Offset(center.dx - radius * 0.3, pinY), pinRadius, pinPaint);

    // Right pin
    canvas.drawCircle(Offset(center.dx + radius * 0.3, pinY), pinRadius, pinPaint);
  }

  @override
  bool shouldRepaint(_CHAdeMOIconPainter oldDelegate) => color != oldDelegate.color;
}

/// Tesla/NACS connector icon painter
class _TeslaIconPainter extends CustomPainter {
  final Color color;

  _TeslaIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Outer shield shape
    final path = Path();

    // Tesla logo outline (shield shape)
    path.moveTo(center.dx, center.dy - radius * 0.8);
    path.lineTo(center.dx + radius * 0.7, center.dy - radius * 0.4);
    path.lineTo(center.dx + radius * 0.8, center.dy);
    path.lineTo(center.dx + radius * 0.5, center.dy + radius * 0.8);
    path.lineTo(center.dx - radius * 0.5, center.dy + radius * 0.8);
    path.lineTo(center.dx - radius * 0.8, center.dy);
    path.lineTo(center.dx - radius * 0.7, center.dy - radius * 0.4);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, fillPaint);

    // Inner connector details
    final innerPath = Path();

    innerPath.moveTo(center.dx, center.dy - radius * 0.5);
    innerPath.lineTo(center.dx + radius * 0.4, center.dy - radius * 0.25);
    innerPath.lineTo(center.dx + radius * 0.45, center.dy);
    innerPath.lineTo(center.dx + radius * 0.3, center.dy + radius * 0.5);
    innerPath.lineTo(center.dx - radius * 0.3, center.dy + radius * 0.5);
    innerPath.lineTo(center.dx - radius * 0.45, center.dy);
    innerPath.lineTo(center.dx - radius * 0.4, center.dy - radius * 0.25);
    innerPath.close();

    final innerFill = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawPath(innerPath, innerFill);

    // Center pin
    final pinPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.12, pinPaint);
  }

  @override
  bool shouldRepaint(_TeslaIconPainter oldDelegate) => color != oldDelegate.color;
}
