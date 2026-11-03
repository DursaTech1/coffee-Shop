import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SocialButton extends StatelessWidget {
  final String type; // 'google' or 'apple'
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 52,
        width: 130,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: type == 'google'
              ? _buildGoogleIcon()
              : _buildAppleIcon(isDark),
        ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }

  Widget _buildAppleIcon(bool isDark) {
    return Icon(
      Icons.apple,
      size: 26,
      color: isDark ? Colors.white : Colors.black,
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    final colorBlue = const Color(0xFF4285F4);
    final colorGreen = const Color(0xFF34A853);
    final colorYellow = const Color(0xFFFBBC05);
    final colorRed = const Color(0xFFEA4335);

    final strokeWidth = w * 0.22;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Draw multi-color circular arc
    paint.color = colorBlue;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        -0.4, 1.2, false, paint);

    paint.color = colorGreen;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        0.8, 1.6, false, paint);

    paint.color = colorYellow;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        2.4, 1.2, false, paint);

    paint.color = colorRed;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        3.6, 1.6, false, paint);

    // Blue horizontal bar
    final barPaint = Paint()
      ..color = colorBlue
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(w * 0.45, h * 0.42, w * 0.5, strokeWidth * 0.8),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
