import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../l10n/app_localizations.dart';
import 'onboard_3.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/assets.dart';
import '../../../../../core/resources/colors.dart';
import '../widget/skipbuttonwidget.dart';
import '../widget/custombluebuttonwidget.dart';
import '../../../auth/presentation/pages/signin.dart';

class Onboard2Page extends StatelessWidget {
  const Onboard2Page({super.key});

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
                MyAssets.onboardImage2,
                width: context.w(375),
                height: context.h(444),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //skip button
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

          // Heading Container (Sized Box area)
          Positioned(
            top: context.h(484),
            left: context.w(33),
            child: SizedBox(
              width: context.w(309),
              height: context.h(163.29611206054688),
              child: Column(
                children: [
                  // Rich Text Heading
                  RichText(
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
                          text: AppLocalizations.of(
                            context,
                          )!.onboard2TitlePart1,
                        ),
                        TextSpan(
                          text: AppLocalizations.of(
                            context,
                          )!.onboard2TitlePart2,
                          style: const TextStyle(
                            color: AppColors.underlineOrange, // Orange color
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Underline under "explore"
          Positioned(
            top: context.h(557),
            left: context.w(196.57), // UPDATED left position
            child: SizedBox(
              width: context.w(102.04370416944452), // UPDATED width
              height: context.h(10.351673304013648), // UPDATED height
              child: SvgPicture.asset(MyAssets.onboardUnderline2),
            ),
          ),

          // Description text
          Positioned(
            top: context.h(575.3),
            left: context.w(36),
            child: SizedBox(
              width: context.w(303),
              height: context.h(72),
              child: Text(
                AppLocalizations.of(context)!.onboard2Description,
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

          // --- UPDATED PAGE INDICATORS ---

          // Rectangle 1 (inactive)
          Positioned(
            top: context.h(672),
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

          // Rectangle 2 (active)
          Positioned(
            top: context.h(672),
            left: context.w(173),
            child: Container(
              width: context.w(35),
              height: context.h(7),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // Rectangle 3 (inactive)
          Positioned(
            top: context.h(672),
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

          // next button
          CustomBottomButton(
            title: AppLocalizations.of(context)!.next, // for this screen
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Onboard3Page()),
              );
            },
          ),
        ],
      ),
    );
  }
}
