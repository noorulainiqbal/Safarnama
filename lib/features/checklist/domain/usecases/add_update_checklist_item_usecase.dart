import '../entities/checklist_item_entity.dart';
import '../repositories/checklist_repository.dart';

class AddOrUpdateChecklistItemUseCase {
  final ChecklistRepository repository;

  AddOrUpdateChecklistItemUseCase(this.repository);

  Future<void> call(String uid, ChecklistItemEntity item) {
    return repository.addOrUpdateItem(uid, item);
  }
}
