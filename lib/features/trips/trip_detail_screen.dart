import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/status_chip.dart';
import 'trip_models.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key, required this.trip});

  final TripDetail trip;

  @override
  Widget build(BuildContext context) {
    final trip = this.trip;

    return Scaffold(
      appBar: AppBar(title: Text(trip.tripId)),
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
                              style: Theme.of(context).textTheme.bodySmall
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
                    value:
                        '${trip.completedStops}/${trip.totalStops} completed',
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
                  ...DeliveryWorkflowState.values
                      .skipWhile(
                        (state) =>
                            state != DeliveryWorkflowState.readyForDispatch,
                      )
                      .map(
                        (state) => _TimelineStep(
                          label: state.label,
                          isDone: _isWorkflowStepDone(
                            trip.workflowState,
                            state,
                          ),
                        ),
                      ),
                ],
              ),
            ),
            SectionTitle(title: 'Stop List', actionLabel: null),
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
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
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

bool _isWorkflowStepDone(
  DeliveryWorkflowState current,
  DeliveryWorkflowState step,
) {
  if (current == DeliveryWorkflowState.failed ||
      current == DeliveryWorkflowState.cancelled) {
    return step == current ||
        DeliveryWorkflowState.values.indexOf(step) <
            DeliveryWorkflowState.values.indexOf(current);
  }
  return DeliveryWorkflowState.values.indexOf(step) <=
      DeliveryWorkflowState.values.indexOf(current);
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
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
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
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
