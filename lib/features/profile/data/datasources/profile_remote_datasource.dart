import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile(String uid);
  Future<void> updateProfile(UserModel user);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  ProfileRemoteDataSourceImpl(this.firestore);

  @override
  Future<UserModel> getProfile(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      final user = UserModel(
        uid: uid,
        firstName: '',
        lastName: '',
        email: '',
        location: '',
        phone: '',
        photoUrl: '',
      );

      await firestore
          .collection('users')
          .doc(uid)
          .set(user.toJson(), SetOptions(merge: true));

      return user;
    }

    return UserModel.fromJson(doc.data()!, uid);
  }

  @override
  Future<void> updateProfile(UserModel user) async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .set(user.toJson(), SetOptions(merge: true));
  }
}
