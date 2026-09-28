import '../entities/checklist_item_entity.dart';
import '../repositories/checklist_repository.dart';

class GetChecklistUseCase {
  final ChecklistRepository repository;

  GetChecklistUseCase(this.repository);

  Future<List<ChecklistItemEntity>> call(String uid) {
    return repository.getChecklist(uid);
  }
}
