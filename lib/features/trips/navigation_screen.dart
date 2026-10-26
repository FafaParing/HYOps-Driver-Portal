import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../../core/widgets/status_chip.dart';
import '../delivery/delivery_models.dart';
import '../delivery/successful_delivery_screen.dart';
import '../history/history_state.dart';
import '../home/home_shell.dart';
import 'trip_state.dart';
import 'trip_models.dart';

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
    final trip = widget.trip;
    final nextStop = trip.stops.isNotEmpty
        ? trip.stops.firstWhere(
            (stop) => stop.status != 'Delivered',
            orElse: () => trip.stops.first,
          )
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Navigation')),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _RouteMapPainter())),
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
                          color: Colors.black.withValues(alpha: 0.08),
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
                        Align(
                          alignment: Alignment.topRight,
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
                          _InfoPill(
                            label: 'Delivery',
                            value: trip.deliveryType,
                          ),
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
                  label: trip.isSingleDelivery
                      ? 'Start Delivery'
                      : 'Start Route',
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CallCustomerButton(
                      onPressed: () => _callCustomer(nextStop),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
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
                            label: 'Cancel delivery',
                            icon: Icons.cancel_outlined,
                            onPressed: () =>
                                _showCancelDialog(context, trip, nextStop),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (_arrived)
              Positioned(
                bottom: AppSpacing.lg,
                left: AppSpacing.md,
                right: AppSpacing.md,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CallCustomerButton(
                      onPressed: () => _callCustomer(nextStop),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PrimaryButton(
                      label: 'Confirm Delivery',
                      icon: Icons.task_alt_outlined,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SuccessfulDeliveryScreen(
                              result: DeliveryResult(
                                tripId: trip.tripId,
                                stopId: nextStop?.stopId ?? 'N/A',
                                customerName:
                                    nextStop?.customerName ?? 'Customer',
                                receiverName:
                                    nextStop?.contactPerson ?? 'Not provided',
                                products: nextStop?.products ?? const [],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _callCustomer(TripStop? stop) async {
    if (stop == null || stop.phoneNumber.trim().isEmpty) {
      _showCallError('No customer phone number is available.');
      return;
    }

    final phoneUri = Uri(scheme: 'tel', path: stop.phoneNumber);
    if (!await launchUrl(phoneUri)) {
      _showCallError('Unable to open the phone dialer.');
    }
  }

  void _showCallError(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showCancelDialog(
    BuildContext context,
    TripDetail trip,
    TripStop? stop,
  ) async {
    if (stop == null) {
      return;
    }

    final navigator = Navigator.of(context);
    String? selectedReason;
    final reasons = [
      'Vehicle issue',
      'Customer requested cancellation',
      'Unsafe route or weather',
      'Unable to reach customer',
      'Other',
    ];
    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final dialogWidth = MediaQuery.sizeOf(context).width - 80;

          return AlertDialog(
            title: const Text('Cancel delivery?'),
            content: SizedBox(
              width: dialogWidth.clamp(220.0, 360.0),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: selectedReason,
                decoration: const InputDecoration(hintText: 'Select a reason'),
                selectedItemBuilder: (context) => reasons
                    .map(
                      (item) => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                items: reasons
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedReason = value;
                  });
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Keep delivery'),
              ),
              FilledButton(
                onPressed: selectedReason == null
                    ? null
                    : () => Navigator.of(dialogContext).pop(selectedReason),
                child: const Text('Cancel delivery'),
              ),
            ],
          );
        },
      ),
    );

    if (!mounted || reason == null) {
      return;
    }

    HistoryStore.instance.addCancelledStop(trip, stop.stopId, reason: reason);
    TripStore.instance.cancelStopAndAdvance(
      tripId: trip.tripId,
      stopId: stop.stopId,
    );
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => HomeShell(
          notificationMessage: 'Delivery cancelled for ${stop.customerName}.',
        ),
      ),
      (route) => false,
    );
  }
}

class _CallCustomerButton extends StatelessWidget {
  const _CallCustomerButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.phone_outlined),
        label: const Text('Call customer'),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
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
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 10,
        ),
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
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    final roadPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.35)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final roadPath = Path()
      ..moveTo(24, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.24,
        size.height * 0.54,
        size.width * 0.40,
        size.height * 0.62,
      )
      ..quadraticBezierTo(
        size.width * 0.60,
        size.height * 0.72,
        size.width * 0.76,
        size.height * 0.40,
      )
      ..quadraticBezierTo(
        size.width * 0.90,
        size.height * 0.18,
        size.width - 24,
        size.height * 0.24,
      );

    canvas.drawPath(roadPath, roadPaint);

    final markerPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.40, size.height * 0.62),
      8,
      markerPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.76, size.height * 0.40),
      8,
      markerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
