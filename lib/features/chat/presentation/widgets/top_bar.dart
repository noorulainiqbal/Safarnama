import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/text_styles.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // top bar row (white background)
        Container(
          width: context.w(375),
          height: context.h(70),
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: context.w(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // left circle with back arrow
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: context.w(44),
                  height: context.w(44),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
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

              // center bot name + status
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Cultural Guide',
                    style: AppTextStyles.semibold(context, context.sp(18)),
                  ),
                  SizedBox(height: context.h(4)),
                  Text(
                    'Active Now',
                    style: AppTextStyles.medium(
                      context,
                      context.sp(14),
                    ).copyWith(color: Colors.green.shade600),
                  ),
                ],
              ),

              // right circle with phone icon (optional - could be used for history)
              GestureDetector(
                onTap: () {
                  // Show chat history or settings
                },
                child: Container(
                  width: context.w(44),
                  height: context.w(44),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    MyAssets.chatPhone,
                    width: context.w(20),
                    height: context.h(20),
                  ),
                ),
              ),
            ],
          ),
        ),

        // thin divider line below top bar
        Container(
          width: context.w(375),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade100,
                width: context.w(2.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
