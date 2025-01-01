import 'package:flutter/material.dart';
import '../main.dart';

class SearchableCurrencyDropdown extends StatelessWidget {
  final Currency value;
  final ValueChanged<Currency?> onChanged;

  const SearchableCurrencyDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<Currency>(
            value: value,
            isExpanded: true,
            items: Currency.values.map((Currency currency) {
              return DropdownMenuItem<Currency>(
                value: currency,
                child: Text('${currency.code} (${currency.symbol})'),
              );
            }).toList(),
            onChanged: (Currency? newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
            onTap: () {
              // Show search dialog when dropdown is tapped
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _CurrencySearchDialog(
                    selectedCurrency: value,
                    onCurrencySelected: (Currency currency) {
                      onChanged(currency);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CurrencySearchDialog extends StatefulWidget {
  final Currency selectedCurrency;
  final ValueChanged<Currency> onCurrencySelected;

  const _CurrencySearchDialog({
    required this.selectedCurrency,
    required this.onCurrencySelected,
  });

  @override
  State<_CurrencySearchDialog> createState() => _CurrencySearchDialogState();
}

class _CurrencySearchDialogState extends State<_CurrencySearchDialog> {
  late TextEditingController _searchController;
  List<Currency> _filteredCurrencies = Currency.values;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_filterCurrencies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCurrencies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCurrencies = Currency.values.where((currency) {
        return currency.code.toLowerCase().contains(query) ||
            currency.symbol.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search currency...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: _filteredCurrencies.length,
                itemBuilder: (context, index) {
                  final currency = _filteredCurrencies[index];
                  return ListTile(
                    title: Text('${currency.code} (${currency.symbol})'),
                    selected: currency == widget.selectedCurrency,
                    onTap: () => widget.onCurrencySelected(currency),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 