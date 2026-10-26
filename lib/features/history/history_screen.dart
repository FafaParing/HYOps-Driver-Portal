import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/status_chip.dart';
import 'history_models.dart';
import 'history_state.dart';

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
    return AnimatedBuilder(
      animation: HistoryStore.instance,
      builder: (context, child) {
        final filteredEntries = _filteredEntries();
        return SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth < 400
                  ? 12.0
                  : 20.0;
              final contentWidth = constraints.maxWidth > 760
                  ? 720.0
                  : constraints.maxWidth - (horizontalPadding * 2);

              return ListView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  18,
                  horizontalPadding,
                  28,
                ),
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: contentWidth,
                      child: _HistoryContent(
                        filteredEntries: filteredEntries,
                        searchController: searchController,
                        selectedFilter: selectedFilter,
                        onFilterChanged: (filter) {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                        onSearchChanged: () => setState(() {}),
                        onClear: () {
                          setState(() {
                            searchController.clear();
                            selectedFilter = 'Today';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  List<HistoryEntry> _filteredEntries() {
    final query = searchController.text.trim().toLowerCase();

    return HistoryStore.instance.entries.where((entry) {
      final matchesFilter = switch (selectedFilter) {
        'Today' => entry.dateLabel.toLowerCase().contains('today'),
        'Week' =>
          entry.dateLabel.toLowerCase().contains('today') ||
              entry.dateLabel.toLowerCase().contains('yesterday') ||
              entry.dateLabel.toLowerCase().contains('week'),
        'Month' => true,
        _ => true,
      };

      final matchesQuery =
          query.isEmpty ||
          entry.title.toLowerCase().contains(query) ||
          entry.subtitle.toLowerCase().contains(query) ||
          entry.tripId.toLowerCase().contains(query);

      return matchesFilter && matchesQuery;
    }).toList();
  }
}

class _HistoryContent extends StatelessWidget {
  const _HistoryContent({
    required this.filteredEntries,
    required this.searchController,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.onSearchChanged,
    required this.onClear,
  });

  final List<HistoryEntry> filteredEntries;
  final TextEditingController searchController;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback onSearchChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('History', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.lg),
        SearchBar(
          controller: searchController,
          hintText: 'Search trips, stops, or trip IDs',
          leading: const Icon(Icons.search),
          onChanged: (_) => onSearchChanged(),
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
                  onSelected: (_) => onFilterChanged(filter),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionTitle(
          title: '${filteredEntries.length} results',
          actionLabel: 'Clear',
          onActionTap: onClear,
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
              child: _HistoryEntryCard(entry: entry),
            ),
          ),
      ],
    );
  }
}

class _HistoryEntryCard extends StatelessWidget {
  const _HistoryEntryCard({required this.entry});

  final HistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => _HistoryReceiptScreen(entry: entry),
          ),
        );
      },
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
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          entry.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
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
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Trip ${entry.tripId} • ${entry.dateLabel}',
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
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

class _HistoryReceiptScreen extends StatelessWidget {
  const _HistoryReceiptScreen({required this.entry});

  final HistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Receipt')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          entry.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      StatusChip(
                        label: entry.status,
                        variant: entry.kind == 'completed'
                            ? StatusChipVariant.success
                            : StatusChipVariant.danger,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Receipt ${entry.receiptNumber}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ReceiptRow(label: 'Trip ID', value: entry.tripId),
                  _ReceiptRow(label: 'Receiver', value: entry.receiverName),
                  _ReceiptRow(label: 'Address', value: entry.address),
                  _ReceiptRow(
                    label: 'Date and time',
                    value: '${entry.deliveryDate} ${entry.deliveryTime}',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Items', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.sm),
                  if (entry.products.isEmpty)
                    const Text(
                      'No products recorded',
                      style: TextStyle(color: AppColors.textSecondary),
                    )
                  else
                    ...entry.products.map(
                      (product) => _ReceiptProductRow(product: product),
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

class _ReceiptProductRow extends StatelessWidget {
  const _ReceiptProductRow({required this.product});

  final String product;

  @override
  Widget build(BuildContext context) {
    final separatorIndex = product.lastIndexOf(' x');
    final name = separatorIndex == -1
        ? product
        : product.substring(0, separatorIndex);
    final quantity = separatorIndex == -1
        ? 'Not recorded'
        : product.substring(separatorIndex + 2);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(name, softWrap: true)),
          const SizedBox(width: AppSpacing.sm),
          Text(
            quantity == 'Not recorded' ? quantity : 'Qty: $quantity',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              softWrap: true,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
