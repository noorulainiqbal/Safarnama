import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../../core/utils/size_extension.dart';

class BookmarkedPlacesHeader extends StatelessWidget {
  final String? title;

  const BookmarkedPlacesHeader({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: context.w(44),
            height: context.w(44),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F9),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              MyAssets.chatBackArrow,
              width: context.w(15),
              height: context.h(15),
            ),
          ),
        ),

        // Title
        Text(
          title ?? AppLocalizations.of(context)!.bookmarkedPlacesTitle,
          style: AppTextStyles.semibold(context, 18),
        ),

        // Spacer to balance the layout
        SizedBox(width: context.w(44)),
      ],
    );
  }
}
