import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/utils/size_extension.dart';

class InputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final VoidCallback onAttach;
  final bool isSending;

  const InputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onAttach,
    this.isSending = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// MESSAGE INPUT
        Expanded(
          child: Container(
            height: context.h(48),
            padding: EdgeInsets.symmetric(horizontal: context.w(16)),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(context.w(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    style: TextStyle(fontSize: context.sp(16)),
                    decoration: InputDecoration(
                      hintText: "Ask about a destination...",
                      hintStyle: TextStyle(
                        fontSize: context.sp(16),
                        color: Colors.grey[600],
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => onSend(),
                  ),
                ),
                GestureDetector(
                  onTap: onAttach,
                  child: SvgPicture.asset(
                    MyAssets.chatAttach,
                    width: context.w(24),
                    height: context.h(24),
                    colorFilter: ColorFilter.mode(
                      Colors.grey[600]!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: context.w(12)),

        /// SEND/MIC BUTTON
        GestureDetector(
          onTap: isSending ? null : onSend,
          child: Container(
            width: context.w(48),
            height: context.h(48),
            decoration: BoxDecoration(
              color: isSending ? Colors.grey[400] : const Color(0xFF1AC4FA),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isSending
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : SvgPicture.asset(
                      MyAssets.chatMic,
                      width: context.w(24),
                      height: context.h(24),
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
