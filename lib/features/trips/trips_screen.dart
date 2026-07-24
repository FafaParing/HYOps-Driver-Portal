import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/status_chip.dart';
import 'trip_detail_screen.dart';
import 'trip_mock_data.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Trips',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Assigned trips for today',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: _SummaryTile(
                    label: 'Trips Today',
                    value: mockTrips.length.toString(),
                    icon: Icons.route_outlined,
                  ),
                ),
                Container(
                  width: 1,
                  height: 44,
                  color: AppColors.border,
                ),
                Expanded(
                  child: _SummaryTile(
                    label: 'In Progress',
                    value: mockTrips
                        .where((trip) => trip.status == 'In Progress')
                        .length
                        .toString(),
                    icon: Icons.timelapse_outlined,
                  ),
                ),
                Container(
                  width: 1,
                  height: 44,
                  color: AppColors.border,
                ),
                Expanded(
                  child: _SummaryTile(
                    label: 'Completed',
                    value: mockTrips
                        .where((trip) => trip.status == 'Completed')
                        .length
                        .toString(),
                    icon: Icons.verified_outlined,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SectionTitle(
            title: 'Active Trips',
            actionLabel: 'Refresh',
            onActionTap: () {},
          ),
          const SizedBox(height: AppSpacing.sm),
          ...mockTrips.map(
            (trip) => Padding(
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
                                trip.tripId,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${trip.totalStops} stops • ${trip.assignedTruck}',
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
                    LinearProgressIndicator(
                      value: trip.progress,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${(trip.progress * 100).round()}% complete',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _TripMetricRow(
                      label: 'Current Stop',
                      value: trip.currentStop,
                    ),
                    _TripMetricRow(
                      label: 'Remaining Stops',
                      value: trip.remainingStops.toString(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    PrimaryButton(
                      label: 'Open Trip',
                      icon: Icons.open_in_new,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TripDetailScreen(trip: trip),
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
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _TripMetricRow extends StatelessWidget {
  const _TripMetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
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
          Flexible(
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