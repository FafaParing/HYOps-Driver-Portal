import 'package:flutter/foundation.dart';

import 'trip_mock_data.dart';
import 'trip_models.dart';

class TripStore extends ChangeNotifier {
  TripStore._();

  static final TripStore instance = TripStore._();

  TripDetail _currentTrip = mockCurrentTrip;
  bool _hasActiveTrip = true;
  final Set<String> _completedTripIds = {
    for (final trip in mockTrips)
      if (trip.status == 'Completed') trip.tripId,
  };

  TripDetail get currentTrip => _currentTrip;
  bool get hasActiveTrip => _hasActiveTrip;

  List<TripDetail> get activeTrips => [
        if (_hasActiveTrip) _currentTrip,
        ...mockTrips.where(
          (trip) =>
              trip.tripId != _currentTrip.tripId &&
              trip.status != 'Completed' &&
              !_completedTripIds.contains(trip.tripId),
        ),
      ];

  void resetToDemoTrip() {
    _currentTrip = mockCurrentTrip;
    _hasActiveTrip = true;
    _completedTripIds
      ..clear()
      ..addAll(
        mockTrips
            .where((trip) => trip.status == 'Completed')
            .map((trip) => trip.tripId),
      );
    notifyListeners();
  }

  void selectTrip(TripDetail trip) {
    _currentTrip = trip;
    _hasActiveTrip = trip.status != 'Completed';
    notifyListeners();
  }

  void completeStopAndAdvance({
    required String tripId,
    required String stopId,
  }) {
    _selectTripById(tripId);
    completeCurrentStop(stopId);

    if (_currentTrip.status != 'Completed') {
      notifyListeners();
      return;
    }

    _advanceAfterCompletedTrip();
  }

  void cancelStopAndAdvance({
    required String tripId,
    required String stopId,
  }) {
    _selectTripById(tripId);
    final updatedStops = _currentTrip.stops.map((stop) {
      if (stop.stopId != stopId) {
        return stop;
      }
      return TripStop(
        stopId: stop.stopId,
        customerName: stop.customerName,
        contactPerson: stop.contactPerson,
        phoneNumber: stop.phoneNumber,
        address: stop.address,
        distance: stop.distance,
        status: 'Cancelled',
        deliveryNumber: stop.deliveryNumber,
        invoiceNumber: stop.invoiceNumber,
        products: stop.products,
      );
    }).toList();

    final remainingStops = updatedStops
        .where((stop) => stop.status != 'Delivered' && stop.status != 'Cancelled')
        .toList();
    _currentTrip = _copyTrip(
      stops: updatedStops,
      completedCount: updatedStops.length - remainingStops.length,
      pendingStops: remainingStops,
    );

    if (remainingStops.isEmpty) {
      _advanceAfterCompletedTrip();
    } else {
      notifyListeners();
    }
  }

  void completeCurrentStop(String stopId) {
    final updatedStops = _currentTrip.stops.map((stop) {
      if (stop.stopId != stopId) {
        return stop;
      }
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
    }).toList();
    final pendingStops =
        updatedStops.where((stop) => stop.status != 'Delivered').toList();
    _currentTrip = _copyTrip(
      stops: updatedStops,
      completedCount: updatedStops.length - pendingStops.length,
      pendingStops: pendingStops,
    );
  }

  void _selectTripById(String tripId) {
    if (_currentTrip.tripId != tripId) {
      _currentTrip = mockTrips.firstWhere((trip) => trip.tripId == tripId);
    }
  }

  void _advanceAfterCompletedTrip() {
    _completedTripIds.add(_currentTrip.tripId);
    final nextTrip = mockTrips.firstWhere(
      (trip) =>
          trip.tripId != _currentTrip.tripId &&
          trip.status != 'Completed' &&
          !_completedTripIds.contains(trip.tripId),
      orElse: () => _currentTrip,
    );
    if (nextTrip.tripId == _currentTrip.tripId) {
      _hasActiveTrip = false;
    } else {
      _currentTrip = nextTrip;
      _hasActiveTrip = true;
    }
    notifyListeners();
  }

  TripDetail _copyTrip({
    required List<TripStop> stops,
    required int completedCount,
    required List<TripStop> pendingStops,
  }) {
    final hasPendingStops = pendingStops.isNotEmpty;
    return TripDetail(
      tripId: _currentTrip.tripId,
      status: hasPendingStops ? 'In Progress' : 'Completed',
      assignedTruck: _currentTrip.assignedTruck,
      driverName: _currentTrip.driverName,
      totalStops: _currentTrip.totalStops,
      completedStops: completedCount,
      currentStop: hasPendingStops ? pendingStops.first.address : 'Completed',
      remainingStops: pendingStops.length,
      progress: _currentTrip.totalStops == 0
          ? 1
          : completedCount / _currentTrip.totalStops,
      nextStop: hasPendingStops ? pendingStops.first.address : 'None',
      warehouse: _currentTrip.warehouse,
      stops: stops,
    );
  }
}
