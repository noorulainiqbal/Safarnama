class UserEntity {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String location;
  final String phone;
  final String photoUrl;

  const UserEntity({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.location,
    required this.phone,
    required this.photoUrl,
  });
}
