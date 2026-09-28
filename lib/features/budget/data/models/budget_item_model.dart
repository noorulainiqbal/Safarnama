import '../../domain/entities/budget_item_entity.dart';
import '../../domain/entities/budget_category.dart';

class BudgetItemModel extends BudgetItemEntity {
  BudgetItemModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.category,
    required super.date,
    required super.userId,
    super.description,
    super.location,
  });

  factory BudgetItemModel.fromEntity(BudgetItemEntity entity) {
    return BudgetItemModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      category: entity.category,
      date: entity.date,
      userId: entity.userId,
      description: entity.description,
      location: entity.location,
    );
  }

  factory BudgetItemModel.fromFirebase(Map<String, dynamic> data, String id) {
    return BudgetItemModel(
      id: id,
      title: data['title'],
      amount: (data['amount'] as num).toDouble(),
      category: BudgetCategory.values.firstWhere(
        (cat) => cat.firebaseKey == data['category'],
        orElse: () => BudgetCategory.other,
      ),
      date: DateTime.fromMillisecondsSinceEpoch(data['date']),
      userId: data['userId'],
      description: data['description'],
      location: data['location'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'title': title,
      'amount': amount,
      'category': category.firebaseKey,
      'date': date.millisecondsSinceEpoch,
      'userId': userId,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
  }
}
