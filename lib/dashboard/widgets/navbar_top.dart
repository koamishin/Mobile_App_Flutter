import 'dart:ui';
import 'package:flutter/material.dart';

/// Glassmorphism top header used across all dashboard pages.
///
/// Renders [title] / [subtitle] on the left and the notification bell on
/// the right, with an optional back button. The same style is used for the
/// home tab and all sub-pages so the chrome stays consistent.
///
/// All colors come from the active [ColorScheme] so the header adapts
/// automatically to light and dark mode.
class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    required this.title,
    this.subtitle,
    this.onNotificationTap,
    this.onAvatarTap,
    this.avatarUrl,
    this.avatarInitial = 'SJ',
    this.showBackButton = false,
    this.onBackPressed,
    super.key,
  });

  /// Page title shown on the left (e.g. "Home", "Grades").
  final String title;

  /// Optional subtitle shown below the title.
  final String? subtitle;

  /// Callback for tapping the notification icon.
  final VoidCallback? onNotificationTap;

  /// Callback for tapping the avatar (typically opens the profile drawer).
  final VoidCallback? onAvatarTap;

  /// Optional network image URL for the avatar. If null or the image fails
  /// to load, [avatarInitial] is shown instead.
  final String? avatarUrl;

  /// Fallback initials shown on the avatar when no image is available.
  final String avatarInitial;

  /// Whether to show a back button on the left (used by pushed sub-pages).
  final bool showBackButton;

  /// Callback for the back button (uses Navigator.pop if null).
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 12,
          sigmaY: 12,
        ), // Glassmorphism frosted effect
        child: Container(
          height: 80,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
          color: scheme.surface.withValues(alpha: 0.65),
          child: SafeArea(
            bottom: false,
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (onAvatarTap != null) ...[
                        _buildAvatarButton(context, scheme),
                        const SizedBox(width: 10),
                      ],
                      Expanded(child: _buildTitleBlock(context, scheme)),
                    ],
                  ),
                ),
                _buildNotificationButton(context, scheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBlock(BuildContext context, ColorScheme scheme) {
    return Row(
      children: [
        if (showBackButton) ...[
          IconButton(
            onPressed:
                onBackPressed ?? () => Navigator.of(context).maybePop(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: scheme.onSurface,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                  letterSpacing: -0.3,
                  height: 1.1,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarButton(BuildContext context, ColorScheme scheme) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onAvatarTap,
        customBorder: const CircleBorder(),
        child: Container(
          height: 44,
          width: 44,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                scheme.primary,
                scheme.tertiary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.32),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: avatarUrl != null
                ? Image.network(
                    avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _buildInitialsFallback(scheme),
                  )
                : _buildInitialsFallback(scheme),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialsFallback(ColorScheme scheme) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.surface,
      ),
      alignment: Alignment.center,
      child: Text(
        avatarInitial,
        style: TextStyle(
          color: scheme.primary,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context, ColorScheme scheme) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.18),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: scheme.primary,
              size: 26,
            ),
            onPressed: onNotificationTap,
          ),
        ),
        Positioned(
          right: 2,
          top: 2,
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: scheme.tertiary,
              shape: BoxShape.circle,
              border: Border.all(
                color: scheme.surface,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: scheme.tertiary.withValues(alpha: 0.55),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
