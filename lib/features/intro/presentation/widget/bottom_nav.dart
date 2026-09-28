import 'package:flutter/material.dart';
import 'package:project/features/places/presentation/pages/search.dart';
import 'package:project/features/chat/presentation/pages/chatbot_page.dart';
import 'package:project/features/profile/presentation/pages/profile.dart';
import 'package:project/features/route/presentation/pages/route.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/assets.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        /// Bottom bar background
        Container(
          height: context.h(70),
          width: double.infinity,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              /// Left side
              Flexible(
                child: _navItem(context, MyAssets.homeicon, "Home", null),
              ),
              Flexible(
                child: _navItem(
                  context,
                  MyAssets.map,
                  "Route",
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RoutePage()),
                  ),
                ),
              ),

              SizedBox(width: context.w(50)), // Space for center Search
              /// Right side
              Flexible(
                child: _navItem(
                  context,
                  MyAssets.chaticon,
                  "Chat",
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatbotPage()),
                  ),
                ),
              ),
              Flexible(
                child: _navItem(
                  context,
                  MyAssets.profileicon,
                  "Profile",
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// Center Search Button
        Positioned(
          bottom: context.h(10),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            child: Container(
              width: context.w(50),
              height: context.w(50),
              padding: EdgeInsets.all(context.w(12)),
              decoration: BoxDecoration(
                color: const Color(0xFF24BAEC),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                MyAssets.search,
                fit: BoxFit.contain,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _navItem(
    BuildContext context,
    dynamic icon,
    String label,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: context.w(28),
            height: context.h(28),
            child: icon is IconData
                ? Icon(icon, color: Colors.white, size: context.sp(24))
                : Image.asset(icon),
          ),
          SizedBox(height: context.h(2)),
          Text(
            label,
            style: TextStyle(
              fontFamily: "SF UI Display",
              fontWeight: FontWeight.w500,
              fontSize: context.sp(12),
              height: 16 / 12,
              letterSpacing: 0,
              color: const Color(0xFF24BAEC),
            ),
          ),
        ],
      ),
    );
  }
}
