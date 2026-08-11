import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/status_chip.dart';
import '../notifications/notifications_screen.dart';
import 'home_mock_data.dart';
import '../trips/navigation_screen.dart';
import '../trips/trip_detail_screen.dart';
import '../trips/trip_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trip = TripStore.instance.currentTrip;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Tasks',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'A smooth day is in progress.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.notifications_none_outlined),
                tooltip: 'Notifications',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.95),
                  AppColors.primary.withOpacity(0.74),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, ${mockDriver.name.split(' ').first}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${trip.remainingStops} stops left today • Keep the route moving',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: const Icon(
                    Icons.route_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Driver Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'All systems are ready for the next checkpoint.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StatusChip(
                      label: mockDriver.status,
                      variant: StatusChipVariant.success,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _KeyValueRow(label: 'Driver', value: mockDriver.name),
                _KeyValueRow(label: 'Driver ID', value: mockDriver.employeeId),
                _KeyValueRow(
                  label: 'Assigned Truck',
                  value: mockTruck.assigned ? mockTruck.number : 'Not assigned',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_shipping_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Trip',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            trip.status,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${(trip.progress * 100).round()}%',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _KeyValueRow(label: 'Trip ID', value: trip.tripId),
                _KeyValueRow(label: 'Truck', value: trip.assignedTruck),
                _KeyValueRow(
                  label: 'Current Stop',
                  value: trip.currentStop,
                ),
                _KeyValueRow(
                  label: 'Remaining Stops',
                  value: trip.remainingStops.toString(),
                ),
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: trip.progress,
                    minHeight: 8,
                    backgroundColor: AppColors.border,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${(trip.progress * 100).round()}% trip progress',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: 'Navigate',
                        icon: Icons.navigation_outlined,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NavigationScreen(
                                trip: trip,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TripDetailScreen(
                                trip: trip,
                              ),
                            ),
                          );
                        },
                        child: const Text('View Trip'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.call_outlined),
                    label: const Text('Call Customer'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.map_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Route Map',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Live map view will appear here soon.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    color: AppColors.background,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _MapPlaceholderPainter(),
                        ),
                      ),
                      Positioned(
                        left: AppSpacing.md,
                        bottom: AppSpacing.md,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Map placeholder',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionTitle(
            title: 'Today\'s Stops',
            actionLabel: 'View All',
            onActionTap: () {},
          ),
          const SizedBox(height: AppSpacing.sm),
          ...trip.stops.map(
            (stop) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppCard(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        stop.stopId.split('-').last,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${stop.customerName}, ${stop.address}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    StatusChip(
                      label: stop.status,
                      variant: stop.status == 'Delivered'
                          ? StatusChipVariant.success
                          : StatusChipVariant.info,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.12)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final linePaint = Paint()
      ..color = AppColors.primary.withOpacity(0.35)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(24, size.height * 0.72)
      ..quadraticBezierTo(size.width * 0.28, size.height * 0.48, size.width * 0.42, size.height * 0.58)
      ..quadraticBezierTo(size.width * 0.58, size.height * 0.68, size.width * 0.74, size.height * 0.36)
      ..quadraticBezierTo(size.width * 0.86, size.height * 0.2, size.width - 24, size.height * 0.26);

    canvas.drawPath(path, linePaint);

    final markerPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.42, size.height * 0.58), 8, markerPaint);
    canvas.drawCircle(Offset(size.width * 0.74, size.height * 0.36), 8, markerPaint);
    canvas.drawCircle(Offset(size.width * 0.86, size.height * 0.2), 8, markerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}