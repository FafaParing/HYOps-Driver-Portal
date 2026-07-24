class TripStop {
  const TripStop({
    required this.stopId,
    required this.customerName,
    required this.contactPerson,
    required this.phoneNumber,
    required this.address,
    required this.distance,
    required this.status,
    required this.deliveryNumber,
    required this.invoiceNumber,
    required this.products,
  });

  final String stopId;
  final String customerName;
  final String contactPerson;
  final String phoneNumber;
  final String address;
  final String distance;
  final String status;
  final String deliveryNumber;
  final String invoiceNumber;
  final List<TripProduct> products;
}

class TripProduct {
  const TripProduct({required this.name, required this.quantity});

  final String name;
  final int quantity;
}

class TripDetail {
  const TripDetail({
    required this.tripId,
    required this.status,
    required this.assignedTruck,
    required this.driverName,
    required this.totalStops,
    required this.completedStops,
    required this.currentStop,
    required this.remainingStops,
    required this.progress,
    required this.nextStop,
    required this.warehouse,
    required this.stops,
  });

  final String tripId;
  final String status;
  final String assignedTruck;
  final String driverName;
  final int totalStops;
  final int completedStops;
  final String currentStop;
  final int remainingStops;
  final double progress;
  final String nextStop;
  final String warehouse;
  final List<TripStop> stops;
}
