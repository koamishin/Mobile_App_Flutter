import 'package:flutter/material.dart';

import '../../models/notification_item.dart';

/// A modal bottom sheet that displays the user's in-app notifications.
///
/// The sheet is intentionally self-contained: callers just call
/// [NotificationsSheet.show] from the bell-tap callback. It manages its
/// own state (filter selection, read/unread toggles) and exits the
/// sheet when the user dismisses.
class NotificationsSheet extends StatefulWidget {
  const NotificationsSheet({super.key, this.items});

  /// The notifications to display. When null, a small sample set is
  /// shown so the user can preview the UI on a fresh install.
  final List<NotificationItem>? items;

  static Future<void> show(
    BuildContext context, {
    List<NotificationItem>? items,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      // Allows the sheet to take up most of the screen height.
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.86,
      ),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,
      builder: (ctx) => NotificationsSheet(items: items),
    );
  }

  @override
  State<NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<NotificationsSheet> {
  /// The user-controlled state: which filter chip is active.
  int _selectedFilter = 0;

  /// Mutable working copy of the notifications. The sheet mutates this
  /// when the user taps "Mark all read" or a card to mark it as read.
  late List<NotificationItem> _items;

  /// Filter chip definitions. Index 0 is "All", then per-category.
  static const _filters = <_FilterChip>[
    _FilterChip(icon: Icons.inbox_rounded, label: 'All'),
    _FilterChip(icon: Icons.mark_email_unread_rounded, label: 'Unread'),
    _FilterChip(
      icon: Icons.assessment_rounded,
      label: 'Grades',
      category: NotificationCategory.grades,
    ),
    _FilterChip(
      icon: Icons.how_to_reg_rounded,
      label: 'Attendance',
      category: NotificationCategory.attendance,
    ),
    _FilterChip(
      icon: Icons.calendar_month_rounded,
      label: 'Schedule',
      category: NotificationCategory.schedule,
    ),
    _FilterChip(
      icon: Icons.monetization_on_rounded,
      label: 'Payments',
      category: NotificationCategory.payments,
    ),
    _FilterChip(
      icon: Icons.campaign_rounded,
      label: 'Announce',
      category: NotificationCategory.announcements,
    ),
    _FilterChip(
      icon: Icons.alarm_rounded,
      label: 'Reminders',
      category: NotificationCategory.reminders,
    ),
  ];

  /// A small built-in sample set so the sheet has content on a fresh
  /// install. The data is realistic enough to demo every category.
  static final List<NotificationItem> _sample = _buildSample();

  static List<NotificationItem> _buildSample() {
    final now = DateTime.now();
    return [
      NotificationItem(
        id: 'n1',
        category: NotificationCategory.grades,
        title: 'New grade posted: Science',
        body: 'You scored 95% on the Photosynthesis Lab. '
            'Great work — your class rank moved up to #3.',
        timestamp: now.subtract(const Duration(minutes: 12)),
        actionLabel: 'View grade',
      ),
      NotificationItem(
        id: 'n2',
        category: NotificationCategory.attendance,
        title: 'Attendance marked for today',
        body: 'You were marked PRESENT for all 4 classes on '
            'May 26, 2026. Keep it up!',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 18)),
      ),
      NotificationItem(
        id: 'n3',
        category: NotificationCategory.schedule,
        title: 'Class room change — Mathematics',
        body: 'Your 1:30 PM Mathematics class has been moved from '
            'Room 204 to Room 311 for today only.',
        timestamp: now.subtract(const Duration(hours: 4)),
        actionLabel: 'Open schedule',
      ),
      NotificationItem(
        id: 'n4',
        category: NotificationCategory.payments,
        title: 'Tuition installment due in 3 days',
        body: 'Your next installment of \$450.00 is due on '
            'June 5, 2026. Pay early to avoid late fees.',
        timestamp: now.subtract(const Duration(hours: 8)),
        isRead: true,
        actionLabel: 'Pay now',
      ),
      NotificationItem(
        id: 'n5',
        category: NotificationCategory.announcements,
        title: 'School-wide assembly tomorrow',
        body: 'All Grade 10 students are required to attend the '
            'career guidance assembly on May 27 at 8:00 AM.',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationItem(
        id: 'n6',
        category: NotificationCategory.reminders,
        title: 'Assignment due tomorrow',
        body: 'Your English essay draft is due by 11:59 PM on '
            'May 27. Aim for at least 800 words.',
        timestamp: now.subtract(const Duration(days: 1, hours: 4)),
        isRead: true,
        actionLabel: 'Open assignment',
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _items = List<NotificationItem>.from(
      widget.items ?? _sample,
    );
  }

  int get _unreadCount => _items.where((n) => !n.isRead).length;

  List<NotificationItem> get _filtered {
    final f = _filters[_selectedFilter];
    if (f.category == null) {
      // "All" or "Unread"
      if (_selectedFilter == 1) {
        return _items.where((n) => !n.isRead).toList();
      }
      return _items;
    }
    return _items.where((n) => n.category == f.category).toList();
  }

  void _markAllRead() {
    setState(() {
      _items = _items.map((n) => n.copyWith(isRead: true)).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _onCardTap(NotificationItem n) {
    setState(() {
      final i = _items.indexWhere((x) => x.id == n.id);
      if (i != -1) _items[i] = _items[i].copyWith(isRead: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final filtered = _filtered;

    return Material(
      color: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top notch / drag indicator (M3 bottom sheet affordance)
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 8),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_active_rounded,
                    color: scheme.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: scheme.onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  if (_unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$_unreadCount new',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: scheme.onPrimaryContainer,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  TextButton(
                    onPressed: _markAllRead,
                    style: TextButton.styleFrom(
                      foregroundColor: scheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Mark all read',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Filter chips
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final f = _filters[index];
                  return _FilterChipWidget(
                    filter: f,
                    selected: _selectedFilter == index,
                    onTap: () => setState(() => _selectedFilter = index),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Body
            Expanded(
              child: filtered.isEmpty
                  ? _EmptyState(filterLabel: _filters[_selectedFilter].label)
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final n = filtered[i];
                        return _NotificationCard(
                          notification: n,
                          onTap: () => _onCardTap(n),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------
// Filter chip
// ----------------------------------------------------------------
class _FilterChip {
  const _FilterChip({
    required this.icon,
    required this.label,
    this.category,
  });
  final IconData icon;
  final String label;
  final NotificationCategory? category;
}

class _FilterChipWidget extends StatelessWidget {
  const _FilterChipWidget({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final _FilterChip filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected
          ? scheme.primaryContainer
          : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected
              ? scheme.primary.withValues(alpha: 0.5)
              : scheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                filter.icon,
                size: 16,
                color: selected
                    ? scheme.onPrimaryContainer
                    : scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                filter.label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: selected
                      ? scheme.onPrimaryContainer
                      : scheme.onSurface,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------
// Notification card
// ----------------------------------------------------------------
class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  final NotificationItem notification;
  final VoidCallback onTap;

  IconData get _icon => switch (notification.category) {
    NotificationCategory.grades => Icons.assessment_rounded,
    NotificationCategory.attendance => Icons.how_to_reg_rounded,
    NotificationCategory.schedule => Icons.calendar_month_rounded,
    NotificationCategory.payments => Icons.monetization_on_rounded,
    NotificationCategory.announcements => Icons.campaign_rounded,
    NotificationCategory.reminders => Icons.alarm_rounded,
  };

  Color _categoryColor(ColorScheme scheme) => switch (notification.category) {
    NotificationCategory.grades => scheme.primary,
    NotificationCategory.attendance => const Color(0xFF27AE60),
    NotificationCategory.schedule => const Color(0xFF6D5DFB),
    NotificationCategory.payments => const Color(0xFF32A89D),
    NotificationCategory.announcements => const Color(0xFFFF8E53),
    NotificationCategory.reminders => const Color(0xFFEB5757),
  };

  String _relativeTime() {
    final diff = DateTime.now().difference(notification.timestamp);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    final d = notification.timestamp;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cat = _categoryColor(scheme);
    final isUnread = !notification.isRead;

    return Material(
      color: isUnread
          ? scheme.primaryContainer.withValues(alpha: 0.30)
          : scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isUnread
                  ? scheme.primary.withValues(alpha: 0.30)
                  : scheme.outlineVariant.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: cat.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_icon, color: cat, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: scheme.onSurface,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: scheme.primary.withValues(alpha: 0.4),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: scheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 12,
                          color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _relativeTime(),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurfaceVariant
                                .withValues(alpha: 0.8),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const Spacer(),
                        if (notification.actionLabel != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: cat.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              notification.actionLabel!,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: cat,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------
// Empty state
// ----------------------------------------------------------------
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filterLabel});

  final String filterLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_rounded,
                color: scheme.onSurfaceVariant,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Nothing in $filterLabel',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'You\'re all caught up. New notifications will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: scheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
