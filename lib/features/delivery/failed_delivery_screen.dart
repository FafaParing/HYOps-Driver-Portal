import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/failure_dialog.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/section_title.dart';
import 'delivery_models.dart';

class FailedDeliveryScreen extends StatefulWidget {
  const FailedDeliveryScreen({
    super.key,
    required this.result,
  });

  final DeliveryResult result;

  @override
  State<FailedDeliveryScreen> createState() => _FailedDeliveryScreenState();
}

class _FailedDeliveryScreenState extends State<FailedDeliveryScreen> {
  String? selectedReason;
  final remarksController = TextEditingController();

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Failed Delivery')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(title: widget.result.customerName),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Trip ${widget.result.tripId} • ${widget.result.stopId}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Reason', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  DropdownButtonFormField<String>(
                    initialValue: selectedReason,
                    items: failedDeliveryReasons
                        .map(
                          (reason) => DropdownMenuItem<String>(
                            value: reason,
                            child: Text(reason),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedReason = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Select a reason',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Remarks', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  CustomTextField(
                    controller: remarksController,
                    hintText: 'Add remarks for the failed delivery',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Timestamp', style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(height: 4),
                        Text('2026-07-21 10:45 AM'),
                        SizedBox(height: AppSpacing.sm),
                        Text('GPS', style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(height: 4),
                        Text('3.1493, 101.6958'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    label: 'Submit Failed Delivery',
                    icon: Icons.report_outlined,
                    onPressed: () {
                      if (selectedReason == null) {
                        showDialog<void>(
                          context: context,
                          builder: (context) => const FailureDialog(
                            title: 'Missing reason',
                            message:
                                'Please select a failure reason before submitting.',
                          ),
                        );
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed delivery submitted')),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}