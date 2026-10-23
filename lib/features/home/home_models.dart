import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class Driver {
  const Driver({
    required this.name,
    required this.employeeId,
    required this.status,
  });

  final String name;
  final String employeeId;
  final String status;
}

class Truck {
  const Truck({
    required this.number,
    required this.plateNumber,
    required this.assigned,
  });

  final String number;
  final String plateNumber;
  final bool assigned;
}

class StopSummary {
  const StopSummary({
    required this.label,
    required this.address,
    required this.status,
  });

  final String label;
  final String address;
  final String status;
}

class TripSummary {
  const TripSummary({
    required this.tripId,
    required this.status,
    required this.assignedTruck,
    required this.totalStops,
    required this.completedStops,
    required this.currentStop,
    required this.remainingStops,
    required this.progress,
    required this.nextStop,
    required this.stops,
  });

  final String tripId;
  final String status;
  final String assignedTruck;
  final int totalStops;
  final int completedStops;
  final String currentStop;
  final int remainingStops;
  final double progress;
  final String nextStop;
  final List<StopSummary> stops;
}

class HomeStatusPalette {
  static const Map<String, Color> tripColors = {
    'Assigned': AppColors.warning,
    'Accepted': AppColors.info,
    'Loading': AppColors.warning,
    'In Progress': AppColors.primary,
    'Completed': AppColors.success,
  };
}