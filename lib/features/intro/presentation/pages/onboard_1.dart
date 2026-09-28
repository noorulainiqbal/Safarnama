import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/assets.dart';
import '../../../../../core/resources/colors.dart';
import '../widget/skipbuttonwidget.dart';
import '../widget/custombluebuttonwidget.dart';
import 'onboard_2.dart';
import '../../../auth/presentation/pages/signin.dart';

class Onboard1Page extends StatelessWidget {
  const Onboard1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Main Image (Rounded only at bottom)
          Positioned(
            top: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(context.w(30)),
                bottomRight: Radius.circular(context.w(30)),
              ),
              child: Image.asset(
                MyAssets.onboardImage1,
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

          // Title Container (RichText)
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
                      text: AppLocalizations.of(context)!.onboard1TitlePart1,
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.onboard1TitlePart2,
                      style: const TextStyle(color: AppColors.underlineOrange),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Underline under "wide"
          Positioned(
            top: context.h(557),
            left: context.w(212.53),
            child: SizedBox(
              width: context.w(62.92),
              height: context.h(10.3),
              child: SvgPicture.asset(MyAssets.onboardUnderline1),
            ),
          ),

          // Description / Subtitle text
          Positioned(
            top: context.h(575.3),
            left: context.w(36),
            child: SizedBox(
              width: context.w(303),
              height: context.h(72),
              child: Text(
                AppLocalizations.of(context)!.onboard1Description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Gill Sans MT",
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
              width: context.w(35),
              height: context.h(7),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            top: context.h(671),
            left: context.w(195),
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
            left: context.w(212),
            child: Container(
              width: context.w(6),
              height: context.h(7),
              decoration: BoxDecoration(
                color: AppColors.skipText,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // Get Started / Next button
          CustomBottomButton(
            title: AppLocalizations.of(context)!.getStarted,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Onboard2Page()),
              );
            },
          ),
        ],
      ),
    );
  }
}
