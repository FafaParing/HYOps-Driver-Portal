import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/confirmation_dialog.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/section_title.dart';
import 'delivery_models.dart';

class SuccessfulDeliveryScreen extends StatefulWidget {
  const SuccessfulDeliveryScreen({
    super.key,
    required this.result,
  });

  final DeliveryResult result;

  @override
  State<SuccessfulDeliveryScreen> createState() => _SuccessfulDeliveryScreenState();
}

class _SuccessfulDeliveryScreenState extends State<SuccessfulDeliveryScreen> {
  final receiverController = TextEditingController();
  final remarksController = TextEditingController();

  @override
  void dispose() {
    receiverController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Successful Delivery')),
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
                  Text('Receiver Name', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  CustomTextField(
                    controller: receiverController,
                    hintText: 'Enter receiver name',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Photo Placeholder', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    width: double.infinity,
                    height: 160,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.photo_camera_outlined, size: 36),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Remarks', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  CustomTextField(
                    controller: remarksController,
                    hintText: 'Add remarks if needed',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.08),
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
                    label: 'Submit Delivery',
                    icon: Icons.check_circle_outline,
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);

                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) => ConfirmationDialog(
                          title: 'Submit delivery?',
                          message: 'This will mark the stop as delivered.',
                          confirmLabel: 'Submit',
                          onConfirm: () => Navigator.of(dialogContext).pop(true),
                        ),
                      );

                      if (!mounted || confirmed != true) {
                        return;
                      }

                      navigator.pop();
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Delivery submitted')),
                      );
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