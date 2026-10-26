import 'package:flutter_test/flutter_test.dart';
import 'package:hyops_driver_portal/features/trips/trip_mock_data.dart';
import 'package:hyops_driver_portal/features/trips/trip_models.dart';
import 'package:hyops_driver_portal/features/trips/trip_state.dart';

void main() {
  group('TripStore', () {
    test('demo trip stop totals match the displayed stop list', () {
      final store = TripStore.instance;
      store.resetToDemoTrip();

      expect(store.currentTrip.totalStops, 4);
      expect(store.currentTrip.completedStops, 3);
      expect(store.currentTrip.remainingStops, 1);
      expect(store.currentTrip.stops, hasLength(4));
    });

    test('next demo trip is ready to ship', () {
      final trip = mockTrips.firstWhere(
        (trip) => trip.tripId == 'TRP-2026-072',
      );

      expect(trip.status, 'Ready to ship');
      expect(trip.workflowState, DeliveryWorkflowState.readyForDispatch);
    });

    test('products include their units', () {
      final trip = mockTrips.firstWhere(
        (trip) => trip.tripId == 'TRP-2026-071',
      );
      final products = trip.stops.last.products;

      expect(products[0].unit, 'bottle');
      expect(products[1].unit, 'pcs');
    });

    test('completing a stop updates the active trip state', () {
      final store = TripStore.instance;
      store.resetToDemoTrip();

      store.completeCurrentStop('STOP-04');

      final trip = store.currentTrip;
      expect(trip.completedStops, 4);
      expect(trip.currentStop, 'Completed');
      expect(trip.nextStop, 'None');
      expect(trip.status, 'Completed');
      expect(
        trip.stops.firstWhere((stop) => stop.stopId == 'STOP-04').status,
        'Delivered',
      );
    });

    test('finishing all trips shows no active trip', () {
      final store = TripStore.instance;
      store.resetToDemoTrip();

      store.completeStopAndAdvance(tripId: 'TRP-2026-071', stopId: 'STOP-04');
      expect(store.hasActiveTrip, isTrue);
      expect(store.currentTrip.tripId, 'TRP-2026-072');

      store.completeStopAndAdvance(tripId: 'TRP-2026-072', stopId: 'STOP-05');

      expect(store.hasActiveTrip, isFalse);
    });
  });
}
