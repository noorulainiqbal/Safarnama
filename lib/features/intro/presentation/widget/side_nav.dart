import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:project/features/places/presentation/pages/surprise_me.dart';
import 'package:project/features/souvenir/presentation/pages/souvenir_list.dart';
import 'package:project/features/translator/presentation/pages/translator.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../currency/presentation/pages/currency.dart';

class SideNavBar extends StatelessWidget {
  const SideNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CurrencyConverterPage()),
            );
          },
          child: _navItem(context, Icons.phone_in_talk_rounded),
        ),
        SizedBox(height: context.h(12)),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TranslatorPage()),
            );
          },
          child: _navItem(context, Icons.menu_book_rounded),
        ),
        SizedBox(height: context.h(12)),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SurpriseMePage()),
            );
          },
          child: _navItem(context, Icons.landscape_rounded),
        ),
        SizedBox(height: context.h(12)),

        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SouvenirPage()),
            );
          },
          child: _navItem(context, Icons.water_drop_rounded),
        ),
      ],
    );
  }

  /// Reusable button
  Widget _navItem(BuildContext context, IconData icon) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.w(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: context.w(20), // blur(200px)
          sigmaY: context.h(20),
        ),
        child: Container(
          width: context.w(60),
          height: context.h(60),
          decoration: BoxDecoration(
            color: const Color(0x993E3E3E),
            borderRadius: BorderRadius.circular(context.w(20)),
          ),
          child: Icon(icon, color: Colors.white, size: context.sp(28)),
        ),
      ),
    );
  }
}
