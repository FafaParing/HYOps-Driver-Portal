import 'package:flutter_test/flutter_test.dart';
import 'package:hyops_driver_portal/features/trips/trip_state.dart';

void main() {
  group('TripStore', () {
    test('completing a stop updates the active trip state', () {
      final store = TripStore.instance;
      store.resetToDemoTrip();

      store.completeCurrentStop('STOP-04');

      final trip = store.currentTrip;
      expect(trip.completedStops, 4);
      expect(trip.currentStop, 'Completed');
      expect(trip.nextStop, 'None');
      expect(trip.status, 'Completed');
      expect(trip.stops.firstWhere((stop) => stop.stopId == 'STOP-04').status, 'Delivered');
    });
  });
}
