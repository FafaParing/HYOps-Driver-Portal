import 'package:flutter_test/flutter_test.dart';
import 'package:hyops_driver_portal/features/history/history_state.dart';
import 'package:hyops_driver_portal/features/trips/trip_state.dart';

void main() {
  group('HistoryStore', () {
    test('adding a delivered stop creates a completed history entry', () {
      HistoryStore.instance.resetToDemo();
      TripStore.instance.resetToDemoTrip();

      final trip = TripStore.instance.currentTrip;
      HistoryStore.instance.addDeliveredStop(trip, 'STOP-04');

      final entry = HistoryStore.instance.entries.firstWhere(
        (item) => item.tripId == trip.tripId && item.title == 'Greenfield Pharmacy',
      );

      expect(entry.status, 'Completed');
      expect(entry.kind, 'completed');
      expect(entry.products.length, 2);
      expect(entry.address, 'Greenfield Pharmacy, Jalan Sentral 8');
    });
  });
}
