import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class CoffeeHubLogo extends StatelessWidget {
  final bool isDark;
  final double iconSize;
  final double fontSize;
  final bool showSubtitle;

  const CoffeeHubLogo({
    super.key,
    this.isDark = false,
    this.iconSize = 48,
    this.fontSize = 28,
    this.showSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppColors.primary;
    final subtitleColor = isDark ? Colors.white70 : AppColors.textSecondaryLight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Coffee Cup with Steam Icon
        CustomPaint(
          size: Size(iconSize, iconSize),
          painter: _CoffeeCupPainter(color: textColor),
        ),
        const SizedBox(height: 8),
        // CoffeeHub Brand Name
        RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: -0.5,
            ),
            children: const [
              TextSpan(text: 'Coffee'),
              TextSpan(
                text: 'Hub',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 4),
          Text(
            'Good Coffee. Better Mood.',
            style: GoogleFonts.poppins(
              fontSize: fontSize * 0.42,
              fontWeight: FontWeight.w400,
              color: subtitleColor,
            ),
          ),
        ],
      ],
    );
  }
}

class _CoffeeCupPainter extends CustomPainter {
  final Color color;
  _CoffeeCupPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Cup Body
    final cupPath = Path()
      ..moveTo(w * 0.22, h * 0.45)
      ..lineTo(w * 0.74, h * 0.45)
      ..lineTo(w * 0.70, h * 0.82)
      ..quadraticBezierTo(w * 0.48, h * 0.95, w * 0.26, h * 0.82)
      ..close();
    canvas.drawPath(cupPath, paint);

    // Cup Handle
    final handlePath = Path()
      ..moveTo(w * 0.73, h * 0.52)
      ..cubicTo(w * 0.95, h * 0.52, w * 0.95, h * 0.75, w * 0.69, h * 0.75);
    canvas.drawPath(handlePath, paint);

    // Saucer Base
    canvas.drawLine(
      Offset(w * 0.15, h * 0.96),
      Offset(w * 0.82, h * 0.96),
      paint,
    );

    // Steams rising (3 curved lines)
    final steamPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.055
      ..strokeCap = StrokeCap.round;

    // Left steam
    final steam1 = Path()
      ..moveTo(w * 0.35, h * 0.35)
      ..quadraticBezierTo(w * 0.31, h * 0.25, w * 0.37, h * 0.15);
    canvas.drawPath(steam1, steamPaint);

    // Middle steam
    final steam2 = Path()
      ..moveTo(w * 0.48, h * 0.35)
      ..quadraticBezierTo(w * 0.52, h * 0.22, w * 0.46, h * 0.10);
    canvas.drawPath(steam2, steamPaint);

    // Right steam
    final steam3 = Path()
      ..moveTo(w * 0.61, h * 0.35)
      ..quadraticBezierTo(w * 0.65, h * 0.25, w * 0.59, h * 0.15);
    canvas.drawPath(steam3, steamPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

