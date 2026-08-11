import 'dart:collection';

import 'trip_models.dart';
import 'trip_mock_data.dart';

class TripStore {
  TripStore._();

  static final TripStore instance = TripStore._();

  TripDetail _currentTrip = mockCurrentTrip;

  TripDetail get currentTrip => _currentTrip;

  void resetToDemoTrip() {
    _currentTrip = mockCurrentTrip;
  }

  void completeCurrentStop(String stopId) {
    final updatedStops = _currentTrip.stops.map((stop) {
      if (stop.stopId == stopId) {
        return TripStop(
          stopId: stop.stopId,
          customerName: stop.customerName,
          contactPerson: stop.contactPerson,
          phoneNumber: stop.phoneNumber,
          address: stop.address,
          distance: stop.distance,
          status: 'Delivered',
          deliveryNumber: stop.deliveryNumber,
          invoiceNumber: stop.invoiceNumber,
          products: stop.products,
        );
      }
      return stop;
    }).toList();

    final completedCount = updatedStops.where((stop) => stop.status == 'Delivered').length;
    final pendingStops = updatedStops.where((stop) => stop.status != 'Delivered').toList();
    final hasPendingStops = pendingStops.isNotEmpty;
    final newStatus = hasPendingStops ? 'In Progress' : 'Completed';
    final nextPendingStop = hasPendingStops ? pendingStops.first : null;
    final nextStop = hasPendingStops ? nextPendingStop!.address : 'None';
    final currentStop = hasPendingStops ? nextPendingStop!.address : 'Completed';

    _currentTrip = TripDetail(
      tripId: _currentTrip.tripId,
      status: newStatus,
      assignedTruck: _currentTrip.assignedTruck,
      driverName: _currentTrip.driverName,
      totalStops: _currentTrip.totalStops,
      completedStops: completedCount,
      currentStop: currentStop,
      remainingStops: hasPendingStops ? pendingStops.length : 0,
      progress: _currentTrip.totalStops > 0 ? completedCount / _currentTrip.totalStops : 1.0,
      nextStop: nextStop,
      warehouse: _currentTrip.warehouse,
      stops: updatedStops,
    );
  }
}
