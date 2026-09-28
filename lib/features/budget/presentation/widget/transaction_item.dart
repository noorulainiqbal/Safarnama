import 'package:flutter/material.dart';

class TransactionItem {
  final IconData icon;
  final String title;
  final String amount;
  final String date;

  TransactionItem({
    required this.icon,
    required this.title,
    required this.amount,
    required this.date,
  });
}
