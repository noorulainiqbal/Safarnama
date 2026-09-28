import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> getProfile(String uid) {
    return remoteDataSource.getProfile(uid);
  }

  @override
  Future<void> updateProfile(UserEntity user) {
    final userModel = UserModel(
      uid: user.uid,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      location: user.location,
      phone: user.phone,
      photoUrl: user.photoUrl,
    );
    return remoteDataSource.updateProfile(userModel);
  }
}
