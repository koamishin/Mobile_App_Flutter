import 'package:flutter/material.dart';

/// Result of a tap on a profile drawer item. The shell uses this to
/// decide what to do (e.g. show a snackbar, navigate, or sign out).
enum ProfileAction { profile, settings, preferences, logout }

/// A modal side panel that shows the student's profile and a menu of
/// account-related actions. Slides in from the right with a scrim
/// behind it (matching the M3 modal navigation drawer spec).
class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    super.key,
    this.userName = 'Sarah Jenkins',
    this.userEmail = 'sarah.jenkins@school.app',
    this.userRole = 'Grade 10 - Section A',
    this.avatarUrl =
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
  });

  final String userName;
  final String userEmail;
  final String userRole;
  final String avatarUrl;

  /// Shows the drawer as a modal route. Returns the [ProfileAction] chosen
  /// by the user, or null if the scrim / close button was tapped.
  static Future<ProfileAction?> show(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).push<ProfileAction>(
      PageRouteBuilder<ProfileAction>(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.45),
        barrierLabel: 'Profile',
        transitionDuration: const Duration(milliseconds: 360),
        reverseTransitionDuration: const Duration(milliseconds: 260),
        pageBuilder: (ctx, anim, sec) {
          return ProfileDrawer(
            userName: 'Sarah Jenkins',
            userEmail: 'sarah.jenkins@school.app',
            userRole: 'Grade 10 - Section A',
          );
        },
        transitionsBuilder: (ctx, anim, sec, child) {
          // Slide from the right + fade.
          final slide = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(anim);
          return FadeTransition(
            opacity: anim,
            child: SlideTransition(position: slide, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mediaWidth = MediaQuery.of(context).size.width;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Side panel aligned to the right.
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: mediaWidth * 0.82,
              constraints: const BoxConstraints(maxWidth: 380),
              height: double.infinity,
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  bottomLeft: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 32,
                    offset: const Offset(-8, 0),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(context, scheme),
                    const SizedBox(height: 8),
                    _buildMenuItem(
                      context,
                      scheme,
                      icon: Icons.person_rounded,
                      label: 'Profile',
                      subtitle: 'View and edit your info',
                      color: scheme.primary,
                      onTap: () => Navigator.of(context)
                          .pop(ProfileAction.profile),
                    ),
                    _buildMenuItem(
                      context,
                      scheme,
                      icon: Icons.settings_rounded,
                      label: 'Settings',
                      subtitle: 'App and account settings',
                      color: scheme.tertiary,
                      onTap: () => Navigator.of(context)
                          .pop(ProfileAction.settings),
                    ),
                    _buildMenuItem(
                      context,
                      scheme,
                      icon: Icons.tune_rounded,
                      label: 'Preferences',
                      subtitle: 'Notifications, theme, language',
                      color: scheme.secondary,
                      onTap: () => Navigator.of(context)
                          .pop(ProfileAction.preferences),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: scheme.outlineVariant,
                      ),
                    ),
                    _buildMenuItem(
                      context,
                      scheme,
                      icon: Icons.logout_rounded,
                      label: 'Logout',
                      subtitle: 'Sign out of your account',
                      color: scheme.error,
                      isDestructive: true,
                      onTap: () => Navigator.of(context)
                          .pop(ProfileAction.logout),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme scheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withValues(alpha: 0.18),
            scheme.secondaryContainer.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.close_rounded,
                    color: scheme.onSurfaceVariant,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Avatar
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [scheme.primary, scheme.tertiary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.surface,
              ),
              child: ClipOval(
                child: Image.network(
                  avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: scheme.primary,
                    alignment: Alignment.center,
                    child: Text(
                      _initials(userName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            userName,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            userEmail,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              userRole,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: scheme.primary,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    ColorScheme scheme, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: color.withValues(alpha: 0.12),
        highlightColor: color.withValues(alpha: 0.06),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDestructive ? color : scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }
}
