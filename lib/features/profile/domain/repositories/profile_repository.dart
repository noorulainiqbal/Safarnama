import '../entities/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> getProfile(String uid);
  Future<void> updateProfile(UserEntity user);
}
