enum DeliveryWorkflowState {
  assigned,
  accepted,
  loading,
  readyForDispatch,
  inTransit,
  arrived,
  delivered,
  failed,
  cancelled,
}

extension DeliveryWorkflowStateDetails on DeliveryWorkflowState {
  String get label {
    switch (this) {
      case DeliveryWorkflowState.assigned:
        return 'Assigned';
      case DeliveryWorkflowState.accepted:
        return 'Accepted';
      case DeliveryWorkflowState.loading:
        return 'Loading';
      case DeliveryWorkflowState.readyForDispatch:
        return 'Ready for dispatch';
      case DeliveryWorkflowState.inTransit:
        return 'In transit';
      case DeliveryWorkflowState.arrived:
        return 'Arrived';
      case DeliveryWorkflowState.delivered:
        return 'Delivered';
      case DeliveryWorkflowState.failed:
        return 'Failed';
      case DeliveryWorkflowState.cancelled:
        return 'Cancelled';
    }
  }

  String get nextAction {
    switch (this) {
      case DeliveryWorkflowState.assigned:
        return 'Accept trip';
      case DeliveryWorkflowState.accepted:
        return 'Prepare goods';
      case DeliveryWorkflowState.loading:
        return 'Finish loading';
      case DeliveryWorkflowState.readyForDispatch:
        return 'Start route';
      case DeliveryWorkflowState.inTransit:
        return 'Continue to customer';
      case DeliveryWorkflowState.arrived:
        return 'Confirm delivery';
      case DeliveryWorkflowState.delivered:
        return 'Delivery complete';
      case DeliveryWorkflowState.failed:
        return 'Review delivery issue';
      case DeliveryWorkflowState.cancelled:
        return 'Delivery cancelled';
    }
  }

  static DeliveryWorkflowState fromStatus(String status) {
    switch (status.toLowerCase()) {
      case 'assigned':
        return DeliveryWorkflowState.assigned;
      case 'accepted':
        return DeliveryWorkflowState.accepted;
      case 'loading':
        return DeliveryWorkflowState.loading;
      case 'ready for dispatch':
        return DeliveryWorkflowState.readyForDispatch;
      case 'in progress':
      case 'navigating':
      case 'pending':
        return DeliveryWorkflowState.inTransit;
      case 'arrived':
        return DeliveryWorkflowState.arrived;
      case 'delivered':
      case 'completed':
        return DeliveryWorkflowState.delivered;
      case 'failed':
        return DeliveryWorkflowState.failed;
      case 'cancelled':
        return DeliveryWorkflowState.cancelled;
      default:
        return DeliveryWorkflowState.assigned;
    }
  }
}

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

  DeliveryWorkflowState get workflowState =>
      DeliveryWorkflowStateDetails.fromStatus(status);
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

  DeliveryWorkflowState get workflowState =>
      DeliveryWorkflowStateDetails.fromStatus(status);

  bool get isSingleDelivery => totalStops == 1;

  String get deliveryType =>
      isSingleDelivery ? 'Single delivery' : 'Multi-delivery';
}
