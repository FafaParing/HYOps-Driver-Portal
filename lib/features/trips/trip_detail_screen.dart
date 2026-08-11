import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/secondary_button.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/status_chip.dart';
import 'route_overview_placeholder.dart';
import 'stop_detail_screen.dart';
import 'trip_models.dart';
import 'trip_state.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key, required this.trip});

  final TripDetail trip;

  @override
  Widget build(BuildContext context) {
    final trip = TripStore.instance.currentTrip;

    return Scaffold(
      appBar: AppBar(
        title: Text(trip.tripId),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trip Information',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Driver ${trip.driverName} • ${trip.assignedTruck}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      StatusChip(
                        label: trip.status,
                        variant: trip.status == 'Completed'
                            ? StatusChipVariant.success
                            : trip.status == 'Loading'
                                ? StatusChipVariant.warning
                                : StatusChipVariant.info,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _InfoRow(label: 'Warehouse', value: trip.warehouse),
                  _InfoRow(label: 'Current Stop', value: trip.currentStop),
                  _InfoRow(label: 'Next Stop', value: trip.nextStop),
                  _InfoRow(
                    label: 'Stops',
                    value: '${trip.completedStops}/${trip.totalStops} completed',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  LinearProgressIndicator(
                    value: trip.progress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${(trip.progress * 100).round()}% trip progress',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
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
                  Text(
                    'Trip Timeline',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _TimelineStep(label: 'Assigned', isDone: true),
                  _TimelineStep(label: 'Accepted', isDone: true),
                  _TimelineStep(label: 'Loading', isDone: trip.progress > 0),
                  _TimelineStep(label: 'In Progress', isDone: trip.progress > 0.2),
                  _TimelineStep(label: 'Completed', isDone: trip.progress >= 1),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            RouteOverviewPlaceholder(
              driverPositionLabel: trip.currentStop,
              warehouseLabel: trip.warehouse,
              stopCount: trip.totalStops,
            ),
            const SizedBox(height: AppSpacing.md),
            SectionTitle(
              title: 'Stop List',
              actionLabel: null,
            ),
            const SizedBox(height: AppSpacing.sm),
            ...trip.stops.map(
              (stop) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${stop.customerName}, ${stop.address}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                          StatusChip(
                            label: stop.status,
                            variant: stop.status == 'Delivered'
                                ? StatusChipVariant.success
                                : stop.status == 'Failed'
                                    ? StatusChipVariant.danger
                                    : StatusChipVariant.info,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _InfoRow(label: 'Distance', value: stop.distance),
                      _InfoRow(label: 'Contact', value: stop.contactPerson),
                      _InfoRow(label: 'Phone', value: stop.phoneNumber),
                      const SizedBox(height: AppSpacing.md),
                      SecondaryButton(
                        label: trip.status == 'In Progress' || trip.status == 'Loading'
                            ? 'Route Active'
                            : 'Open Stop',
                        icon: trip.status == 'In Progress' || trip.status == 'Loading'
                            ? Icons.lock_outline
                            : Icons.open_in_new,
                        onPressed: trip.status == 'In Progress' || trip.status == 'Loading'
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => StopDetailScreen(
                                      stop: stop,
                                      tripId: trip.tripId,
                                    ),
                                  ),
                                );
                              },
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
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({required this.label, required this.isDone});

  final String label;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final color = isDone ? AppColors.primary : AppColors.border;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isDone ? FontWeight.w600 : FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }
}