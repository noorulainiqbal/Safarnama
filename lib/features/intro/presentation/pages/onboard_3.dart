import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/assets.dart';
import '../../../../../core/resources/colors.dart';
import '../widget/skipbuttonwidget.dart';
import '../widget/custombluebuttonwidget.dart';
import '../../../auth/presentation/pages/signin.dart';

class Onboard3Page extends StatelessWidget {
  const Onboard3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Main Image (Rounded at bottom)
          Positioned(
            top: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(context.w(30)),
                bottomRight: Radius.circular(context.w(30)),
              ),
              child: Image.asset(
                MyAssets.onboardImage3,
                width: context.w(375),
                height: context.h(444),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Skip button
          SkipButton(
            top: 56,
            left: 325,
            text: AppLocalizations.of(context)!.skip,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );
            },
          ),

          // Title text (RichText)
          Positioned(
            top: context.h(484),
            left: context.w(33),
            child: SizedBox(
              width: context.w(309),
              height: context.h(83.59),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Geometr415 Blk BT Black',
                    fontWeight: FontWeight.w400,
                    fontSize: context.sp(30),
                    height: 36 / 30,
                    letterSpacing: 0,
                    color: AppColors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: AppLocalizations.of(context)!.onboard3TitlePart1,
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.onboard3TitlePart2,
                      style: const TextStyle(color: AppColors.underlineOrange),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Underline under "people"
          Positioned(
            top: context.h(557),
            left: context.w(250),
            child: SizedBox(
              width: context.w(88.72),
              height: context.h(10.29),
              child: SvgPicture.asset(MyAssets.onboardUnderline3),
            ),
          ),

          // Subtitle / description text
          Positioned(
            top: context.h(575.3),
            left: context.w(36),
            child: SizedBox(
              width: context.w(303),
              height: context.h(72),
              child: Text(
                AppLocalizations.of(context)!.onboard3Description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Gill Sans MT Regular',
                  fontWeight: FontWeight.w400,
                  fontSize: context.sp(16),
                  height: 24 / 16,
                  letterSpacing: 0,
                  color: AppColors.subtitleGrey,
                ),
              ),
            ),
          ),

          // --- Page Indicators ---
          Positioned(
            top: context.h(671),
            left: context.w(156),
            child: Container(
              width: context.w(13),
              height: context.h(7),
              decoration: BoxDecoration(
                color: AppColors.skipText,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            top: context.h(671),
            left: context.w(173),
            child: Container(
              width: context.w(6),
              height: context.h(7),
              decoration: BoxDecoration(
                color: AppColors.skipText,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            top: context.h(671),
            left: context.w(183),
            child: Container(
              width: context.w(35),
              height: context.h(7),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // Next / Sign In button
          CustomBottomButton(
            title: AppLocalizations.of(context)!.next,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignInPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
