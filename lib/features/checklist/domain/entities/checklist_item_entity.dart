class ChecklistItemEntity {
  final String id;
  final String title;
  final bool isChecked;
  final String category; // 'essential' or 'rainy'

  const ChecklistItemEntity({
    required this.id,
    required this.title,
    this.isChecked = false,
    required this.category,
  });
}
