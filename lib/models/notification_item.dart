import 'package:flutter/material.dart';

/// The 6 high-level notification categories a user can opt in / out of.
enum NotificationCategory {
  grades,
  attendance,
  schedule,
  payments,
  announcements,
  reminders,
}

/// A single in-app notification entry shown in the bell's bottom sheet.
@immutable
class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.actionLabel,
  });

  final String id;
  final NotificationCategory category;

  /// Short, single-line title (e.g. "New grade posted").
  final String title;

  /// 1-2 sentence body with detail.
  final String body;

  /// When the notification was emitted. The sheet renders a relative
  /// timestamp like "2m ago" or "Yesterday".
  final DateTime timestamp;
  final bool isRead;

  /// Optional CTA label (e.g. "View grade", "Open schedule"). When
  /// present, the sheet renders a small action chip on the card.
  final String? actionLabel;

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
    id: id,
    category: category,
    title: title,
    body: body,
    timestamp: timestamp,
    isRead: isRead ?? this.isRead,
    actionLabel: actionLabel,
  );
}
