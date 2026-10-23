import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/status_chip.dart';
import '../notifications/notifications_screen.dart';
import '../trips/navigation_screen.dart';
import '../trips/trip_detail_screen.dart';
import '../trips/trip_models.dart';
import '../trips/trip_state.dart';
import 'home_mock_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: TripStore.instance,
      builder: (context, child) {
        if (!TripStore.instance.hasActiveTrip) {
          return const _NoTripsState();
        }

        final trip = TripStore.instance.currentTrip;
        final firstName = mockDriver.name.split(' ').first;
        final nextStop = trip.stops.firstWhere(
          (stop) => stop.status != 'Delivered',
          orElse: () => trip.stops.first,
        );
        final pendingStops =
            trip.stops.where((stop) => stop.status != 'Delivered').toList();
        final deliveredStops =
            trip.stops.where((stop) => stop.status == 'Delivered').toList();

        return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        children: [
          _HomeHeader(
            firstName: firstName,
            onNotificationsPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 26),
          _RouteOverview(
            trip: trip,
            firstName: firstName,
          ),
          const SizedBox(height: 18),
          _SectionHeading(
            title: 'Next delivery',
            actionLabel: 'Navigate',
            onActionPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NavigationScreen(trip: trip),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          _NextStopCard(
            stop: nextStop,
            orderNumber: trip.stops.indexOf(nextStop) + 1,
            totalOrders: trip.stops.length,
            onStartRoute: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NavigationScreen(trip: trip),
                ),
              );
            },
          ),
          const SizedBox(height: 28),
          _SectionHeading(
            title: 'Delivery queue',
            actionLabel: 'View trip',
            onActionPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TripDetailScreen(trip: trip),
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            '${trip.stops.length} orders on this route • Follow the order shown',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          if (pendingStops.isNotEmpty)
            ...pendingStops.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _StopRow(
                      stop: entry.value,
                      orderNumber: trip.stops.indexOf(entry.value) + 1,
                      isNext: entry.key == 0,
                    ),
                  ),
                ),
          if (deliveredStops.isNotEmpty) ...[
            const SizedBox(height: 8),
            const _CompletedLabel(),
            const SizedBox(height: 8),
            ...deliveredStops.map(
              (stop) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _StopRow(
                  stop: stop,
                  orderNumber: trip.stops.indexOf(stop) + 1,
                ),
              ),
            ),
          ],
        ],
      ),
        );
      },
    );
  }
}

class _NoTripsState extends StatelessWidget {
  const _NoTripsState();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        children: [
          _HomeHeader(
            firstName: mockDriver.name.split(' ').first,
            onNotificationsPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 42),
          AppCard(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.assignment_turned_in_outlined,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'No trips as of now',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You have completed all assigned deliveries. '
                  'New trips will appear here when they are assigned.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.45,
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

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.firstName,
    required this.onNotificationsPressed,
  });

  final String firstName;
  final VoidCallback onNotificationsPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            firstName.substring(0, 1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, $firstName',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 17,
                      letterSpacing: -0.2,
                    ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Friday, 23 October 2026',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onNotificationsPressed,
          tooltip: 'Notifications',
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.border),
            fixedSize: const Size(44, 44),
          ),
          icon: const Icon(Icons.notifications_none_rounded, size: 21),
        ),
      ],
    );
  }
}

class _RouteOverview extends StatelessWidget {
  const _RouteOverview({required this.trip, required this.firstName});

  final TripDetail trip;
  final String firstName;

  @override
  Widget build(BuildContext context) {
    final totalOrders = trip.stops.length;
    final completedOrders =
        trip.stops.where((stop) => stop.status == 'Delivered').length;
    final remainingOrders = totalOrders - completedOrders;
    final progress = totalOrders == 0 ? 1.0 : completedOrders / totalOrders;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 19, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'DELIVERY ROUTE',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Text(
                trip.tripId,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            trip.deliveryType,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            '$remainingOrders deliveries remaining',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Keep the route moving, $firstName.',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 22),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '${(progress * 100).round()}% complete',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$completedOrders of $totalOrders deliveries',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18,
                letterSpacing: -0.2,
              ),
        ),
        const Spacer(),
        if (actionLabel != null)
          TextButton(
            onPressed: onActionPressed,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class _NextStopCard extends StatelessWidget {
  const _NextStopCard({
    required this.stop,
    required this.orderNumber,
    required this.totalOrders,
    required this.onStartRoute,
  });

  final TripStop stop;
  final int orderNumber;
  final int totalOrders;
  final VoidCallback onStartRoute;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 19,
                color: AppColors.primary,
              ),
              const SizedBox(width: 7),
              Text(
                'ORDER $orderNumber OF $totalOrders',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
              const Spacer(),
              StatusChip(
                label: stop.status,
                variant: stop.status == 'Delivered'
                    ? StatusChipVariant.success
                    : StatusChipVariant.info,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            stop.customerName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 17,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            '${stop.products.length} ${stop.products.length == 1 ? 'item' : 'items'} to hand over',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            stop.address,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 3),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: stop.products
                  .map(
                    (product) => _ProductLine(product: product),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 12,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.route_outlined,
                    size: 16,
                    color: AppColors.muted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    stop.distance,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180),
                child: PrimaryButton(
                  label: 'Start route',
                  icon: Icons.navigation_outlined,
                  onPressed: onStartRoute,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductLine extends StatelessWidget {
  const _ProductLine({required this.product});

  final TripProduct product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          const Icon(Icons.inventory_2_outlined, size: 15, color: AppColors.muted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              product.name,
              softWrap: true,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            'x${product.quantity}',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StopRow extends StatelessWidget {
  const _StopRow({
    required this.stop,
    required this.orderNumber,
    this.isNext = false,
  });

  final TripStop stop;
  final int orderNumber;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final isDelivered = stop.status == 'Delivered';

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDelivered
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDelivered
                  ? Icons.check_rounded
                  : isNext
                      ? Icons.navigation_rounded
                      : Icons.circle_outlined,
              size: 18,
              color: isDelivered ? AppColors.success : AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order $orderNumber  ·  ${stop.customerName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${stop.products.length} ${stop.products.length == 1 ? 'item' : 'items'}  ·  ${stop.address}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isDelivered ? 'DONE' : isNext ? 'NEXT' : 'UP NEXT',
            style: TextStyle(
              color: isDelivered ? AppColors.success : AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedLabel extends StatelessWidget {
  const _CompletedLabel();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline, size: 16, color: AppColors.success),
        const SizedBox(width: 7),
        Text(
          'COMPLETED DELIVERIES',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
        ),
      ],
    );
  }
}
