import 'package:flutter/material.dart';

/// Reusable preference-row widgets used by [PreferencesPage].
///
/// All tiles share the same visual language: a colored leading icon, a
/// title + optional subtitle, and a trailing control (switch, value
/// indicator, segmented choice, slider, or chevron). They look at home
/// on the existing dashboard cards thanks to the shared white surface
/// + M3 elevation.

/// ------------------- Switch tile -------------------
class SwitchPreferenceTile extends StatelessWidget {
  const SwitchPreferenceTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _BaseTile(
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeThumbColor: scheme.primary,
      ),
    );
  }
}

/// ------------------- Choice tile (segmented + chevron) -------------------
class ChoicePreferenceTile<T> extends StatelessWidget {
  const ChoicePreferenceTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.valueLabel,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final String valueLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _BaseTile(
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            valueLabel,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right_rounded,
            color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
            size: 22,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

/// ------------------- Slider tile -------------------
class SliderPreferenceTile extends StatelessWidget {
  const SliderPreferenceTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.valueLabel,
    required this.onChanged,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String valueLabel;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _BaseTile(
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      trailing: Text(
        valueLabel,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: scheme.primary,
        ),
      ),
      // Slider gets a wider area below the title row.
      isExpandable: true,
      expanded: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 4,
          activeTrackColor: scheme.primary,
          inactiveTrackColor: scheme.surfaceContainerHighest,
          thumbColor: scheme.primary,
          overlayColor: scheme.primary.withValues(alpha: 0.12),
        ),
        child: Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// ------------------- Action tile (chevron only) -------------------
class ActionPreferenceTile extends StatelessWidget {
  const ActionPreferenceTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailingText,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _BaseTile(
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) ...[
            Text(
              trailingText!,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Icon(
            Icons.chevron_right_rounded,
            color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
            size: 22,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

// =============================================================
// Internal base — gives every tile a consistent visual rhythm.
// =============================================================
class _BaseTile extends StatelessWidget {
  const _BaseTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isExpandable = false,
    this.expanded,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isExpandable;
  final Widget? expanded;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: iconColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle!,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: scheme.onSurfaceVariant,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    ?trailing,
                  ],
                ),
                if (isExpandable && expanded != null) ...[
                  const SizedBox(height: 4),
                  expanded!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
