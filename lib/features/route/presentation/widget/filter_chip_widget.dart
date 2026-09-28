import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/place_enitity.dart';
import '../provider/route_provider.dart';

class FilterChipWidget extends StatelessWidget {
  final PlaceCategory category;

  const FilterChipWidget({super.key, required this.category});

  String get label {
    switch (category) {
      case PlaceCategory.food:
        return 'Food';
      case PlaceCategory.shopping:
        return 'Shopping';
      case PlaceCategory.gasStation:
        return 'Gas Station';
      default:
        return '';
    }
  }

  String get emoji {
    switch (category) {
      case PlaceCategory.food:
        return '🍔';
      case PlaceCategory.shopping:
        return '🛍️';
      case PlaceCategory.gasStation:
        return '⛽';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RouteProvider>(context);
    final isSelected = provider.selectedCategories.contains(category);

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'SF UI Display',
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 14,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => provider.toggleCategory(category),
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF49111C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? const Color(0xFF49111C) : Colors.grey[300]!,
          width: 1,
        ),
      ),
    );
  }
}
