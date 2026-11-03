import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final steps = [
      _TrackingStep(
        title: 'Order Placed',
        time: '9:45 AM',
        isCompleted: true,
        isActive: false,
      ),
      _TrackingStep(
        title: 'Preparing Your Coffee',
        time: '9:50 AM',
        isCompleted: true,
        isActive: false,
      ),
      _TrackingStep(
        title: 'Out for Delivery',
        time: '10:10 AM',
        isCompleted: false,
        isActive: true,
      ),
      _TrackingStep(
        title: 'Delivered',
        time: '',
        isCompleted: false,
        isActive: false,
      ),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              provider.setNavIndex(0);
            }
          },
        ),
        title: Text(
          'Track Order',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Vertical Step Progress Tracker
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    final step = steps[index];
                    final isLast = index == steps.length - 1;

                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Indicator Node + Connecting Line
                          Column(
                            children: [
                              _buildStepNode(step),
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2.5,
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    color: step.isCompleted
                                        ? AppColors.success
                                        : (isDark ? AppColors.borderDark : const Color(0xFFDCC8B8)),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 20),

                          // Step Title & Time
                          Padding(
                            padding: const EdgeInsets.only(bottom: 34.0, top: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step.title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: step.isActive || step.isCompleted
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: step.isCompleted || step.isActive
                                        ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                                        : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                  ),
                                ),
                                if (step.time.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    step.time,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Delivery Scooter Illustration at bottom
              Center(
                child: SizedBox(
                  width: 170,
                  height: 120,
                  child: Image.asset(
                    'assets/images/scooter.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.two_wheeler_rounded,
                      size: 80,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Return to Home button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    provider.setNavIndex(0);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Back to Home',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepNode(_TrackingStep step) {
    if (step.isCompleted) {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: AppColors.success,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 16,
        ),
      );
    } else if (step.isActive) {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: Color(0xFFE2D6CB),
          shape: BoxShape.circle,
        ),
      );
    }
  }
}

class _TrackingStep {
  final String title;
  final String time;
  final bool isCompleted;
  final bool isActive;

  _TrackingStep({
    required this.title,
    required this.time,
    required this.isCompleted,
    required this.isActive,
  });
}
