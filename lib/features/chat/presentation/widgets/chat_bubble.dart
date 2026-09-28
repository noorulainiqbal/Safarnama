import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/text_styles.dart';

class ChatBubble extends StatelessWidget {
  final double width;
  final bool isSender;
  final String message;
  final String timestamp;
  final bool showGreenTick;
  final bool timestampBelow;

  const ChatBubble({
    super.key,
    required this.width,
    required this.isSender,
    required this.message,
    required this.timestamp,
    this.showGreenTick = false,
    this.timestampBelow = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color senderColor = const Color(0xFFE3F3FB);
    final Color receiverColor = Colors.grey.shade100;

    if (isSender) {
      // Blue sender bubble
      return Container(
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: context.w(12),
          vertical: context.h(10),
        ),
        decoration: BoxDecoration(
          color: senderColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.w(12)),
            topRight: Radius.circular(context.w(12)),
            bottomRight: Radius.circular(context.w(1)),
            bottomLeft: Radius.circular(context.w(12)),
          ),
        ),
        child: timestampBelow
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style: AppTextStyles.regular(
                      context,
                      14,
                    ).copyWith(color: Colors.black),
                  ),
                  SizedBox(height: context.h(4)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timestamp,
                        style: AppTextStyles.regular(
                          context,
                          12,
                        ).copyWith(color: Colors.grey.shade600),
                      ),
                      SizedBox(width: context.w(6)),
                      SvgPicture.asset(
                        showGreenTick
                            ? MyAssets.chatGreenTick
                            : MyAssets.chatGreyTick,
                        width: context.w(12),
                        height: context.h(7),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      message,
                      style: AppTextStyles.regular(
                        context,
                        14,
                      ).copyWith(color: Colors.black),
                    ),
                  ),
                  SizedBox(width: context.w(6)),
                  Text(
                    timestamp,
                    style: AppTextStyles.regular(
                      context,
                      12,
                    ).copyWith(color: Colors.grey.shade600),
                  ),
                  SizedBox(width: context.w(6)),
                  SvgPicture.asset(
                    showGreenTick
                        ? MyAssets.chatGreenTick
                        : MyAssets.chatGreyTick,
                    width: context.w(12),
                    height: context.h(7),
                  ),
                ],
              ),
      );
    } else {
      // Grey receiver bubble
      return Container(
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: context.w(12),
          vertical: context.h(10),
        ),
        decoration: BoxDecoration(
          color: receiverColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.w(12)),
            topRight: Radius.circular(context.w(12)),
            bottomLeft: Radius.circular(context.w(1)),
            bottomRight: Radius.circular(context.w(12)),
          ),
        ),
        child: timestampBelow
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style: AppTextStyles.regular(
                      context,
                      14,
                    ).copyWith(color: Colors.black87),
                  ),
                  SizedBox(height: context.h(4)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timestamp,
                        style: AppTextStyles.regular(
                          context,
                          12,
                        ).copyWith(color: Colors.grey.shade600),
                      ),
                      SizedBox(width: context.w(6)),
                      SvgPicture.asset(
                        showGreenTick
                            ? MyAssets.chatGreenTick
                            : MyAssets.chatGreyTick,
                        width: context.w(12),
                        height: context.h(7),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      message,
                      style: AppTextStyles.regular(
                        context,
                        14,
                      ).copyWith(color: Colors.black87),
                    ),
                  ),
                  SizedBox(width: context.w(6)),
                  Text(
                    timestamp,
                    style: AppTextStyles.regular(
                      context,
                      12,
                    ).copyWith(color: Colors.grey.shade600),
                  ),
                  SizedBox(width: context.w(6)),
                  SvgPicture.asset(
                    showGreenTick
                        ? MyAssets.chatGreenTick
                        : MyAssets.chatGreyTick,
                    width: context.w(12),
                    height: context.h(7),
                  ),
                ],
              ),
      );
    }
  }
}
