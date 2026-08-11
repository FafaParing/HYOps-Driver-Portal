import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hyops_driver_portal/features/trips/navigation_screen.dart';
import 'package:hyops_driver_portal/features/trips/trip_models.dart';

void main() {
  testWidgets('Navigation info pill wraps long addresses without overflow', (tester) async {
    final trip = TripDetail(
      tripId: 'T-100',
      status: 'In Progress',
      assignedTruck: 'Truck 1',
      driverName: 'Driver',
      totalStops: 1,
      completedStops: 0,
      currentStop: 'Stop 1',
      remainingStops: 1,
      progress: 0.5,
      nextStop: 'Stop 1',
      warehouse: 'Warehouse A',
      stops: [
        TripStop(
          stopId: 'S-1',
          customerName: 'Alex',
          contactPerson: 'Alex',
          phoneNumber: '0123456789',
          address:
              'Lot 12, North Market Avenue, Taman Tunam, Kuala Lumpur, Malaysia, very long address that should wrap instead of overflowing',
          distance: '3 km',
          status: 'Pending',
          deliveryNumber: 'D-1',
          invoiceNumber: 'INV-1',
          products: const [],
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: NavigationScreen(trip: trip),
      ),
    );

    await tester.tap(find.text('Start Route'));
    await tester.pumpAndSettle();

    

    final flexible = tester.widget<Flexible>(find.byType(Flexible).first);
    expect(flexible.fit, FlexFit.loose);
  });
}
