import '../trips/trip_models.dart';

class DeliveryResult {
  const DeliveryResult({
    required this.tripId,
    required this.stopId,
    required this.customerName,
    required this.receiverName,
    required this.products,
  });

  final String tripId;
  final String stopId;
  final String customerName;
  final String receiverName;
  final List<TripProduct> products;
}

const failedDeliveryReasons = [
  'Customer unavailable',
  'Customer refused',
  'Store closed',
  'Incorrect address',
  'Unable to locate customer',
  'Vehicle issue',
  'Weather conditions',
  'Other',
];
