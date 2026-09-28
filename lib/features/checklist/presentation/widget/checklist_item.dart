import 'package:flutter/material.dart';

class ChecklistItem {
  final TextEditingController titleController;
  bool isChecked;
  final String id;
  final String category; // 'essential' or 'rainy'

  ChecklistItem({
    required String title,
    this.isChecked = false,
    required this.id,
    required this.category,
  }) : titleController = TextEditingController(text: title);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': titleController.text,
      'isChecked': isChecked,
      'category': category,
    };
  }
}
