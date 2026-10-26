import 'package:flutter/foundation.dart';

import '../trips/trip_models.dart';
import 'history_models.dart';

class HistoryStore extends ChangeNotifier {
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
      receiverName: 'Lina Ho',
      products: ['Glucose Meter x1 pcs', 'Test Strips x20 pcs'],
      address: 'City Center Boulevard 9',
      deliveryDate: '2026-10-26',
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
        receiverName: 'Lina Ho',
        products: ['Glucose Meter x1 pcs', 'Test Strips x20 pcs'],
        address: 'City Care Clinic, 9 Boulevard Avenue, Downtown Kuala Lumpur',
        deliveryDate: '2026-10-26',
        deliveryTime: '09:30',
        receiptNumber: 'RCPT-1001',
      ),
    ];
    notifyListeners();
  }

  void addDeliveredStop(TripDetail trip, String stopId) {
    final stop = trip.stops.firstWhere(
      (item) => item.stopId == stopId,
      orElse: () => trip.stops.first,
    );

    final entry = HistoryEntry(
      title: stop.customerName,
      subtitle:
          'Delivered ${stop.products.fold<int>(0, (sum, product) => sum + product.quantity)} products',
      dateLabel: 'Today',
      status: 'Completed',
      kind: 'completed',
      tripId: trip.tripId,
      receiverName: stop.contactPerson,
      products: stop.products
          .map((product) => '${product.name} x${product.quantity} ${product.unit}')
          .toList(),
      address: stop.address,
      deliveryDate: '2026-10-26',
      deliveryTime: 'Now',
      receiptNumber: 'RCPT-${trip.tripId.split('-').last}',
    );

    _entries = [entry, ..._entries];
    notifyListeners();
  }

  void addCancelledStop(
    TripDetail trip,
    String stopId, {
    required String reason,
  }) {
    final stop = trip.stops.firstWhere(
      (item) => item.stopId == stopId,
      orElse: () => trip.stops.first,
    );

    final entry = HistoryEntry(
      title: stop.customerName,
      subtitle: 'Cancelled delivery • $reason',
      dateLabel: 'Today',
      status: 'Cancelled',
      kind: 'cancelled',
      tripId: trip.tripId,
      receiverName: stop.contactPerson,
      products: stop.products
          .map((product) => '${product.name} x${product.quantity} ${product.unit}')
          .toList(),
      address: stop.address,
      deliveryDate: '2026-10-26',
      deliveryTime: 'Now',
      receiptNumber: 'CANCEL-${trip.tripId.split('-').last}',
      reason: reason,
    );

    _entries = [entry, ..._entries];
    notifyListeners();
  }
}
