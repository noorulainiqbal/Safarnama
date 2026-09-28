import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

class ProfileProvider extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileProvider({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  });

  String? get _uid {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  UserEntity? _user;
  UserEntity? get user => _user;

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();

  // Country code
  String countryCode = '+88';
  final List<String> countryCodes = [
    '+1',
    '+44',
    '+49',
    '+61',
    '+81',
    '+88',
    '+91',
    '+92',
    '+971',
  ];

  void setCountryCode(String value) {
    countryCode = value;
    notifyListeners();
  }

  // Location dropdown
  String selectedLocation = 'Sylhet Bangladesh';
  final List<String> locations = [
    'Sylhet Bangladesh',
    'Dhaka Bangladesh',
    'New York USA',
    'London UK',
    'Dubai UAE',
  ];

  void setLocation(String value) {
    selectedLocation = value;
    locationController.text = value;
    notifyListeners();
  }

  // Profile image (local for now)
  String? photoUrl;

  void pickProfileImage() {
    photoUrl = 'assets/images/default_profile.png';
    notifyListeners();
  }

  Future<void> loadProfile() async {
    final uid = _uid;
    if (uid == null) return;

    _user = await getProfileUseCase(uid);

    firstNameController.text = _user!.firstName;
    lastNameController.text = _user!.lastName;
    locationController.text = _user!.location.isEmpty
        ? selectedLocation
        : _user!.location;
    phoneController.text = _user!.phone;

    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> saveProfile() async {
    final uid = _uid;
    if (uid == null) {
      debugPrint('❌ Cannot save profile: No user logged in');
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('📝 START: Saving profile for $uid');
      debugPrint(
        '📝 Data: First=${firstNameController.text}, Last=${lastNameController.text}',
      );

      final updatedUser = UserEntity(
        uid: uid,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: _user?.email ?? '',
        location: selectedLocation,
        phone: '$countryCode${phoneController.text}',
        photoUrl: photoUrl ?? '',
      );

      // Update Firebase Auth Display Name
      try {
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseAuth.instance.currentUser!.updateDisplayName(
            firstNameController.text,
          );
          debugPrint('✅ Auth display name updated');
        }
      } catch (e) {
        debugPrint('⚠️ Failed to update display name: $e');
        // Continue saving to Firestore even if Auth update fails
      }

      await updateProfileUseCase(updatedUser);
      _user = updatedUser;
      debugPrint('✅ Firestore profile updated');

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ Save critical failure: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    locationController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
