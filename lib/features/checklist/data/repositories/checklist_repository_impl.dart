import '../../domain/entities/checklist_item_entity.dart';
import '../../domain/repositories/checklist_repository.dart';
import '../datasources/checklist_remote_data_source.dart';
import '../models/checklist_item_model.dart';

class ChecklistRepositoryImpl implements ChecklistRepository {
  final ChecklistRemoteDataSource remoteDataSource;

  ChecklistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ChecklistItemEntity>> getChecklist(String uid) async {
    return await remoteDataSource.getChecklist(uid);
  }

  @override
  Future<void> addOrUpdateItem(String uid, ChecklistItemEntity item) async {
    final model = ChecklistItemModel(
      id: item.id,
      title: item.title,
      isChecked: item.isChecked,
      category: item.category,
    );
    await remoteDataSource.addOrUpdateItem(uid, model);
  }

  @override
  Future<void> deleteItem(String uid, String itemId) async {
    await remoteDataSource.deleteItem(uid, itemId);
  }
}
