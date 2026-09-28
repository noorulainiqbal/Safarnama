import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/checklist_item_model.dart';

abstract class ChecklistRemoteDataSource {
  Future<List<ChecklistItemModel>> getChecklist(String uid);
  Future<void> addOrUpdateItem(String uid, ChecklistItemModel item);
  Future<void> deleteItem(String uid, String itemId);
}

class ChecklistRemoteDataSourceImpl implements ChecklistRemoteDataSource {
  final FirebaseFirestore firestore;

  ChecklistRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ChecklistItemModel>> getChecklist(String uid) async {
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('checklist')
        .get();

    return snapshot.docs
        .map((doc) => ChecklistItemModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> addOrUpdateItem(String uid, ChecklistItemModel item) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('checklist')
        .doc(item.id)
        .set(item.toJson());
  }

  @override
  Future<void> deleteItem(String uid, String itemId) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('checklist')
        .doc(itemId)
        .delete();
  }
}
