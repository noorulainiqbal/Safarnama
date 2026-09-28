import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../l10n/app_localizations.dart';
import 'onboard_1.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/assets.dart';
import '../../../../../core/resources/colors.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue, // bg color: #24BAEC
      body: Stack(
        children: [
          /// Splash Icon
          Positioned(
            top: context.h(284), // top: 284px
            left: context.w(87), // left: 87px
            child: SizedBox(
              width: context.w(200), // width: 200px
              height: context.h(200), // height: 200px
              child: SvgPicture.asset(
                MyAssets.splashicon,
                width: context.w(200),
                height: context.h(200),
              ),
            ),
          ),

          /// Text: Safarnama
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: context.h(721)),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Onboard1Page(),
                    ),
                  );
                },
                child: SizedBox(
                  width: context.w(250),
                  child: Text(
                    AppLocalizations.of(context)!.appTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Geometr415 Blk BT Black',
                      fontSize: context.sp(34),
                      height: 42 / 34,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
