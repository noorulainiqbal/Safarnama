import 'package:flutter/material.dart';
import '../widget/profile_header.dart';
import '../widget/profile_info_section.dart';
import '../widget/profile_stats_section.dart';
import '../widget/profile_menu_list.dart';
import '../../../../core/utils/size_extension.dart';

import 'package:provider/provider.dart';
import '../provider/profile_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
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

                // Header with back and edit buttons
                ProfileHeader(),

                SizedBox(height: context.h(32)),

                // Profile picture, name, and email
                ProfileInfoSection(),

                SizedBox(height: context.h(32)),

                // Stats section (Reward Points, Travel Trips, Bucket List)
                ProfileStatsSection(),

                SizedBox(height: context.h(40)),

                // Menu list
                ProfileMenuList(),

                SizedBox(height: context.h(32)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
