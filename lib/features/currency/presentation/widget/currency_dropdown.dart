import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/currency_provider.dart';

class CurrencyDropdown extends StatelessWidget {
  final bool isFromCurrency;
  final VoidCallback? onTap;

  const CurrencyDropdown({super.key, required this.isFromCurrency, this.onTap});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CurrencyProvider>(context);
    final currency = isFromCurrency
        ? provider.fromCurrency
        : provider.toCurrency;

    if (currency == null) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: onTap ?? () => _showCurrencyPicker(context, isFromCurrency),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currency.flagEmoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 4),
            Text(
              currency.code,
              style: const TextStyle(
                fontFamily: 'SF UI Display',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF1B1E28),
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Color(0xFF1B1E28),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, bool isFromCurrency) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CurrencyPickerSheet(isFromCurrency: isFromCurrency),
    );
  }
}

class CurrencyPickerSheet extends StatelessWidget {
  final bool isFromCurrency;

  const CurrencyPickerSheet({super.key, required this.isFromCurrency});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CurrencyProvider>(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Select Currency',
                style: TextStyle(
                  fontFamily: 'SF UI Display',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: const Color(0xFF1B1E28),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search currencies...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFFF7029)),
                  ),
                ),
                onChanged: (value) {
                  // Implement search functionality
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: provider.allCurrencies.length,
                itemBuilder: (context, index) {
                  final currency = provider.allCurrencies[index];
                  return ListTile(
                    leading: Text(
                      currency.flagEmoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      currency.code,
                      style: const TextStyle(
                        fontFamily: 'SF UI Display',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      currency.name,
                      style: const TextStyle(
                        fontFamily: 'SF UI Display',
                        fontSize: 14,
                        color: Color(0xFF7D848D),
                      ),
                    ),
                    trailing: provider.latestRates.containsKey(currency.code)
                        ? Text(
                            provider.latestRates[currency.code]!
                                .toStringAsFixed(4),
                            style: const TextStyle(
                              fontFamily: 'SF UI Display',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF7029),
                            ),
                          )
                        : null,
                    onTap: () {
                      if (isFromCurrency) {
                        provider.setFromCurrency(currency);
                      } else {
                        provider.setToCurrency(currency);
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
