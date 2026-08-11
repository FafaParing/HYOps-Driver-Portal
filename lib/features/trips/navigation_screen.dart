import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../../core/widgets/status_chip.dart';
import '../delivery/delivery_models.dart';
import '../delivery/successful_delivery_screen.dart';
import 'trip_models.dart';
import 'trip_state.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key, required this.trip});

  final TripDetail trip;

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late bool _routeStarted;
  late bool _arrived;
  late String _statusLabel;

  @override
  void initState() {
    super.initState();
    _routeStarted = false;
    _arrived = false;
    _statusLabel = widget.trip.status;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trip = TripStore.instance.currentTrip;
    final nextStop = trip.stops.isNotEmpty
        ? trip.stops.firstWhere(
            (stop) =>
                stop.customerName == trip.nextStop ||
                stop.customerName == trip.currentStop ||
                stop.stopId == trip.currentStop,
            orElse: () => trip.stops.first,
          )
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _RouteMapPainter(),
              ),
            ),
            Positioned(
              top: AppSpacing.md,
              left: AppSpacing.md,
              right: AppSpacing.md,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _arrived
                                    ? 'Arrived at destination'
                                    : _routeStarted
                                        ? 'Route in progress'
                                        : 'Ready to start',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _arrived
                                    ? 'You have reached ${nextStop?.address ?? trip.nextStop}. Please confirm the delivery.'
                                    : _routeStarted
                                        ? 'Driving to ${nextStop?.address ?? trip.nextStop}'
                                        : 'Tap start when you are ready to go.',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(
                          child: StatusChip(
                            label: _arrived
                                ? 'Arrived'
                                : _routeStarted
                                    ? 'Active'
                                    : _statusLabel,
                            variant: _arrived || _routeStarted
                                ? StatusChipVariant.success
                                : _statusLabel == 'Completed'
                                    ? StatusChipVariant.success
                                    : _statusLabel == 'Loading'
                                        ? StatusChipVariant.warning
                                        : StatusChipVariant.info,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_routeStarted && !_arrived)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          _InfoPill(label: 'ETA', value: '8 min'),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (!_routeStarted)
              Positioned(
                bottom: AppSpacing.lg,
                left: AppSpacing.md,
                right: AppSpacing.md,
                child: PrimaryButton(
                  label: 'Start Route',
                  icon: Icons.play_arrow_outlined,
                  onPressed: () {
                    setState(() {
                      _routeStarted = true;
                      _statusLabel = 'In Progress';
                    });
                  },
                ),
              ),
            if (_routeStarted && !_arrived)
              Positioned(
                bottom: AppSpacing.lg,
                left: AppSpacing.md,
                right: AppSpacing.md,
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: 'Arrived',
                        icon: Icons.check_circle_outline,
                        onPressed: () {
                          setState(() {
                            _arrived = true;
                            _statusLabel = 'Arrived';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: SecondaryButton(
                        label: 'Call Customer',
                        icon: Icons.call_outlined,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            if (_arrived)
              Positioned(
                bottom: AppSpacing.lg,
                left: AppSpacing.md,
                right: AppSpacing.md,
                child: PrimaryButton(
                  label: 'Confirm Delivery',
                  icon: Icons.task_alt_outlined,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SuccessfulDeliveryScreen(
                          result: DeliveryResult(
                            tripId: trip.tripId,
                            stopId: nextStop?.stopId ?? 'N/A',
                            customerName: nextStop?.customerName ?? 'Customer',
                          ),
                        ),
                      ),
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

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 240),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
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

class _StopStep extends StatelessWidget {
  const _StopStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isActive,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withOpacity(0.12)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    final roadPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.35)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final roadPath = Path()
      ..moveTo(24, size.height * 0.78)
      ..quadraticBezierTo(size.width * 0.24, size.height * 0.54, size.width * 0.40, size.height * 0.62)
      ..quadraticBezierTo(size.width * 0.60, size.height * 0.72, size.width * 0.76, size.height * 0.40)
      ..quadraticBezierTo(size.width * 0.90, size.height * 0.18, size.width - 24, size.height * 0.24);

    canvas.drawPath(roadPath, roadPaint);

    final markerPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.40, size.height * 0.62), 8, markerPaint);
    canvas.drawCircle(Offset(size.width * 0.76, size.height * 0.40), 8, markerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
