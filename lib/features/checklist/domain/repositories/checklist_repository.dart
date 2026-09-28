import '../entities/checklist_item_entity.dart';

abstract class ChecklistRepository {
  Future<List<ChecklistItemEntity>> getChecklist(String uid);
  Future<void> addOrUpdateItem(String uid, ChecklistItemEntity item);
  Future<void> deleteItem(String uid, String itemId);
}
