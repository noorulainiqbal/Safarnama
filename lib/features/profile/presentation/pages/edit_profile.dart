import 'package:flutter/material.dart';
import '../widget/edit_profile_header.dart';
import '../widget/edit_profile_info_section.dart';
import '../widget/edit_profile_form.dart';
import '../../../../core/utils/size_extension.dart';

import 'package:provider/provider.dart';
import '../provider/profile_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  void initState() {
    super.initState();
    // Ensure controllers are populated with current data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(24)),
            child: Column(
              children: [
                SizedBox(height: context.h(16)),
                EditProfileHeader(),
                SizedBox(height: context.h(32)),
                EditProfileInfoSection(),
                SizedBox(height: context.h(32)),
                EditProfileForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
