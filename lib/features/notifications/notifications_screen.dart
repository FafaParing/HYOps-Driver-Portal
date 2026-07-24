import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/section_title.dart';
import 'notifications_mock_data.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: SafeArea(
        child: mockNotifications.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: EmptyState(
                  title: 'No notifications',
                  message: 'New trip and delivery alerts will appear here.',
                  icon: Icons.notifications_none_outlined,
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  SectionTitle(
                    title: 'Recent Alerts',
                    actionLabel: 'Mark all read',
                    onActionTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...mockNotifications.map(
                    (notification) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: AppCard(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: notification.isUnread
                                    ? AppColors.primary.withValues(alpha: 0.12)
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                              child: Icon(
                                _iconFor(notification.icon),
                                color: notification.isUnread
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          notification.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: notification.isUnread
                                                    ? FontWeight.w700
                                                    : FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        notification.timeLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notification.message,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  IconData _iconFor(String iconName) {
    switch (iconName) {
      case 'assignment':
        return Icons.assignment_turned_in_outlined;
      case 'update':
        return Icons.update_outlined;
      case 'cancel':
        return Icons.cancel_outlined;
      case 'alarm':
        return Icons.notifications_active_outlined;
      default:
        return Icons.notifications_none_outlined;
    }
  }
}