import '../repositories/checklist_repository.dart';

class DeleteChecklistItemUseCase {
  final ChecklistRepository repository;

  DeleteChecklistItemUseCase(this.repository);

  Future<void> call(String uid, String itemId) {
    return repository.deleteItem(uid, itemId);
  }
}
