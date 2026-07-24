class DeliveryResult {
  const DeliveryResult({
    required this.tripId,
    required this.stopId,
    required this.customerName,
  });

  final String tripId;
  final String stopId;
  final String customerName;
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