import '../trips/trip_models.dart';
import 'history_models.dart';

class HistoryStore {
  HistoryStore._();

  static final HistoryStore instance = HistoryStore._();

  List<HistoryEntry> _entries = const [
    HistoryEntry(
      title: 'City Care Clinic',
      subtitle: 'Delivered 4 products',
      dateLabel: 'Today, 09:30',
      status: 'Completed',
      kind: 'completed',
      tripId: 'TRP-2026-070',
      products: ['Glucose Meter', 'Test Strips'],
      address: 'City Center Boulevard 9',
      signature: 'Signed by Lina Ho',
      deliveryTime: '09:30',
      receiptNumber: 'RCPT-1001',
    ),
  ];

  List<HistoryEntry> get entries => _entries;

  void resetToDemo() {
    _entries = const [
      HistoryEntry(
        title: 'City Care Clinic',
        subtitle: 'Delivered 4 products',
        dateLabel: 'Today, 09:30',
        status: 'Completed',
        kind: 'completed',
        tripId: 'TRP-2026-070',
        products: ['Glucose Meter', 'Test Strips'],
        address: 'City Care Clinic, 9 Boulevard Avenue, Downtown Kuala Lumpur',
        signature: 'Signed by Lina Ho',
        deliveryTime: '09:30',
        receiptNumber: 'RCPT-1001',
      ),
    ];
  }

  void addDeliveredStop(TripDetail trip, String stopId) {
    final stop = trip.stops.firstWhere(
      (item) => item.stopId == stopId,
      orElse: () => trip.stops.first,
    );

    final entry = HistoryEntry(
      title: stop.customerName,
      subtitle: 'Delivered ${stop.products.fold<int>(0, (sum, product) => sum + product.quantity)} products',
      dateLabel: 'Today',
      status: 'Completed',
      kind: 'completed',
      tripId: trip.tripId,
      products: stop.products.map((product) => '${product.name} x${product.quantity}').toList(),
      address: stop.address,
      signature: 'Signed by ${stop.contactPerson}',
      deliveryTime: 'Now',
      receiptNumber: 'RCPT-${trip.tripId.split('-').last}',
    );

    _entries = [entry, ..._entries];
  }
}
