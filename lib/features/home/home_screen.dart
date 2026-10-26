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
        final lastName = mockDriver.name.split(' ').last;
        final nextStop = trip.stops.firstWhere(
          (stop) => stop.status != 'Delivered',
          orElse: () => trip.stops.first,
        );
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            children: [
              _HomeHeader(
                firstName: firstName,
                lastName: lastName,
                onNotificationsPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 26),
              _CurrentTripCard(trip: trip),
              const SizedBox(height: 18),
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
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TripDetailScreen(trip: trip),
                    ),
                  );
                },
                icon: const Icon(Icons.list_alt_outlined),
                label: const Text('View all stops and workflow'),
              ),
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
            lastName: mockDriver.name.split(' ').last,
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 8),
                const Text(
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
    required this.lastName,
    required this.onNotificationsPressed,
  });

  final String firstName;
  final String lastName;
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
                '$firstName $lastName',
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

class _CurrentTripCard extends StatelessWidget {
  const _CurrentTripCard({required this.trip});

  final TripDetail trip;

  @override
  Widget build(BuildContext context) {
    final state = trip.workflowState;
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current trip',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  state.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  state.nextAction,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          StatusChip(
            label: state.label,
            variant: state == DeliveryWorkflowState.delivered
                ? StatusChipVariant.success
                : state == DeliveryWorkflowState.failed ||
                      state == DeliveryWorkflowState.cancelled
                ? StatusChipVariant.danger
                : StatusChipVariant.info,
          ),
        ],
      ),
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
    final state = stop.workflowState;

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
                label: state.label,
                variant: state == DeliveryWorkflowState.delivered
                    ? StatusChipVariant.success
                    : state == DeliveryWorkflowState.failed ||
                          state == DeliveryWorkflowState.cancelled
                    ? StatusChipVariant.danger
                    : StatusChipVariant.info,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            stop.customerName,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontSize: 17),
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
                  .map((product) => _ProductLine(product: product))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180),
                child: PrimaryButton(
                  label: stop.workflowState == DeliveryWorkflowState.inTransit
                      ? 'Continue route'
                      : 'Start route',
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
          const Icon(
            Icons.inventory_2_outlined,
            size: 15,
            color: AppColors.muted,
          ),
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
            '${product.quantity} ${product.unit}',
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
