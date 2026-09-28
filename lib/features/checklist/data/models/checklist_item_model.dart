import '../../domain/entities/checklist_item_entity.dart';

class ChecklistItemModel extends ChecklistItemEntity {
  const ChecklistItemModel({
    required super.id,
    required super.title,
    super.isChecked,
    required super.category,
  });

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json, String id) {
    return ChecklistItemModel(
      id: id,
      title: json['title'] ?? '',
      isChecked: json['isChecked'] ?? false,
      category: json['category'] ?? 'essential',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'isChecked': isChecked, 'category': category};
  }
}
