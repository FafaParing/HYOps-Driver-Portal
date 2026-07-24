import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/status_chip.dart';
import 'history_mock_data.dart';
import 'history_models.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final searchController = TextEditingController();
  String selectedFilter = 'Today';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntries = _filteredEntries();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'History',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Completed trips and failed deliveries',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SearchBar(
            controller: searchController,
            hintText: 'Search trips, stops, or trip IDs',
            leading: const Icon(Icons.search),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: ['Today', 'Week', 'Month']
                .map(
                  (filter) => ChoiceChip(
                    label: Text(filter),
                    selected: selectedFilter == filter,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionTitle(
            title: '${filteredEntries.length} results',
            actionLabel: 'Clear',
            onActionTap: () {
              setState(() {
                searchController.clear();
                selectedFilter = 'Today';
              });
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          if (filteredEntries.isEmpty)
            const EmptyState(
              title: 'No history found',
              message: 'Try another search or time filter.',
              icon: Icons.history_outlined,
            )
          else
            ...filteredEntries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: entry.kind == 'completed'
                              ? AppColors.success.withValues(alpha: 0.12)
                              : AppColors.danger.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Icon(
                          entry.kind == 'completed'
                              ? Icons.check_circle_outline
                              : Icons.error_outline,
                          color: entry.kind == 'completed'
                              ? AppColors.success
                              : AppColors.danger,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall,
                                  ),
                                ),
                                StatusChip(
                                  label: entry.status,
                                  variant: entry.kind == 'completed'
                                      ? StatusChipVariant.success
                                      : StatusChipVariant.danger,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry.subtitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Trip ${entry.tripId} • ${entry.dateLabel}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<HistoryEntry> _filteredEntries() {
    final query = searchController.text.trim().toLowerCase();

    return mockHistoryEntries.where((entry) {
      final matchesFilter = switch (selectedFilter) {
        'Today' => entry.dateLabel.toLowerCase().contains('today'),
        'Week' => entry.dateLabel.toLowerCase().contains('today') ||
            entry.dateLabel.toLowerCase().contains('yesterday') ||
            entry.dateLabel.toLowerCase().contains('week'),
        'Month' => true,
        _ => true,
      };

      final matchesQuery = query.isEmpty ||
          entry.title.toLowerCase().contains(query) ||
          entry.subtitle.toLowerCase().contains(query) ||
          entry.tripId.toLowerCase().contains(query);

      return matchesFilter && matchesQuery;
    }).toList();
  }
}