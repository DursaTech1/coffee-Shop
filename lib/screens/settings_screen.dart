import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import 'auth/login_screen.dart';
import 'onboarding_screen.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Language Option
            _buildSettingCard(
              isDark: isDark,
              icon: Icons.language_rounded,
              title: 'Language',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'English (US)',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ],
              ),
              onTap: () {
                _showLanguageSheet(context);
              },
            ),
            const SizedBox(height: 10),

            // Django Backend Status & Configuration
            _buildSettingCard(
              isDark: isDark,
              icon: Icons.cloud_done_outlined,
              title: 'Backend API',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: ApiService.isConnected ? Colors.green : const Color(0xFFFFA000),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    ApiService.isConnected ? 'Connected' : 'Configure',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ApiService.isConnected ? Colors.green : const Color(0xFFFFA000),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ],
              ),
              onTap: () {
                _showBackendConfigDialog(context, provider);
              },
            ),
            const SizedBox(height: 10),

            // App Intro / Onboarding (Replay Onboarding slides)
            _buildSettingCard(
              isDark: isDark,
              icon: Icons.slideshow_rounded,
              title: 'App Intro / Onboarding',
              trailing: Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                );
              },
            ),
            const SizedBox(height: 10),

            // Dark Mode Option (with working Switch!)
            _buildSettingCard(
              isDark: isDark,
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              trailing: Switch.adaptive(
                value: provider.isDarkMode,
                activeThumbColor: AppColors.accent,
                onChanged: (val) => provider.toggleTheme(),
              ),
            ),
            const SizedBox(height: 10),

            // Privacy Policy
            _buildSettingCard(
              isDark: isDark,
              icon: Icons.shield_outlined,
              title: 'Privacy Policy',
              trailing: Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
              onTap: () {
                _showInfoDialog(
                  context,
                  'Privacy Policy',
                  'At CoffeeHub, your privacy and data security are our top priorities. We only use your information to ensure freshly brewed coffee reaches your doorstep swiftly.',
                );
              },
            ),
            const SizedBox(height: 10),

            // Terms & Conditions
            _buildSettingCard(
              isDark: isDark,
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              trailing: Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
              onTap: () {
                _showInfoDialog(
                  context,
                  'Terms & Conditions',
                  'By using the CoffeeHub application, you agree to our standard terms of service. Freshness guaranteed on every cup!',
                );
              },
            ),
            const SizedBox(height: 10),

            // Contact Us
            _buildSettingCard(
              isDark: isDark,
              icon: Icons.headset_mic_outlined,
              title: 'Contact Us',
              trailing: Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
              onTap: () {
                _showInfoDialog(
                  context,
                  'Contact Us',
                  'Support Email: support@coffeehub.com\nPhone: +1 800-COFFEE-1\nAddress: 221B Baker Street, London',
                );
              },
            ),
            const SizedBox(height: 18),

            // Log Out Option
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Log Out'),
                    content: const Text('Are you sure you want to log out of CoffeeHub?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                        child: const Text('Log Out', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        size: 18,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Log Out',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Select Language',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: const Text('English (US)'),
              trailing: const Icon(Icons.check, color: AppColors.primary),
              onTap: () => Navigator.of(ctx).pop(),
            ),
            ListTile(
              title: const Text('Amharic (አማርኛ)'),
              onTap: () => Navigator.of(ctx).pop(),
            ),
            ListTile(
              title: const Text('French (Français)'),
              onTap: () => Navigator.of(ctx).pop(),
            ),
            ListTile(
              title: const Text('Arabic (العربية)'),
              onTap: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void _showBackendConfigDialog(BuildContext context, AppProvider provider) {
    final controller = TextEditingController(text: ApiService.baseUrl);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Django Backend API'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: ApiService.isConnected ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ApiService.isConnected
                          ? 'Status: Connected (200 OK)'
                          : 'Status: Disconnected',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ApiService.isConnected ? Colors.green : Colors.red,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'API URL:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'e.g. http://10.0.2.2:8000/api',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Emulator: http://10.0.2.2:8000/api\n• Physical Phone: http://<YOUR_PC_IP>:8000/api\n• Web/Desktop: http://127.0.0.1:8000/api',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (controller.text.trim().isNotEmpty) {
                    ApiService.setCustomBaseUrl(controller.text.trim());
                  }
                  final ok = await ApiService.checkConnection();
                  if (ok) {
                    await provider.loadDataFromBackend();
                  }
                  setState(() {});
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(ok
                            ? '✅ Connected to Django backend!'
                            : '❌ Could not connect to ${controller.text.trim()}'),
                        backgroundColor: ok ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Test & Sync'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
