import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../../core/utils/size_extension.dart';
import '../provider/profile_provider.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(context, 'First Name'),
        SizedBox(height: context.h(8)),
        _input(context, provider.firstNameController),
        SizedBox(height: context.h(24)),

        _label(context, 'Last Name'),
        SizedBox(height: context.h(8)),
        _input(context, provider.lastNameController),
        SizedBox(height: context.h(24)),

        _label(context, 'Location'),
        SizedBox(height: context.h(8)),
        _dropdown(
          context,
          provider.selectedLocation,
          provider.locations,
          provider.setLocation,
        ),
        SizedBox(height: context.h(24)),

        _label(context, 'Mobile Number'),
        SizedBox(height: context.h(8)),
        _phoneInput(context, provider),
      ],
    );
  }

  Widget _label(BuildContext context, String text) {
    return Text(text, style: AppTextStyles.medium(context, 18));
  }

  Widget _input(BuildContext context, TextEditingController controller) {
    return Container(
      width: context.w(335),
      height: context.h(48),
      padding: EdgeInsets.symmetric(horizontal: context.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(context.w(16)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(border: InputBorder.none),
              style: AppTextStyles.regular(context, 16),
            ),
          ),
          SvgPicture.asset(MyAssets.edittick),
        ],
      ),
    );
  }

  Widget _dropdown(
    BuildContext context,
    String value,
    List<String> items,
    Function(String) onChanged,
  ) {
    return Container(
      width: context.w(335),
      height: context.h(48),
      padding: EdgeInsets.symmetric(horizontal: context.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(context.w(16)),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }

  Widget _phoneInput(BuildContext context, ProfileProvider provider) {
    return Container(
      width: context.w(335),
      height: context.h(56),
      padding: EdgeInsets.symmetric(horizontal: context.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(context.w(16)),
      ),
      child: Row(
        children: [
          DropdownButton<String>(
            value: provider.countryCode,
            underline: const SizedBox(),
            items: provider.countryCodes
                .map((code) => DropdownMenuItem(value: code, child: Text(code)))
                .toList(),
            onChanged: (v) => provider.setCountryCode(v!),
          ),
          SizedBox(width: context.w(16)),
          Expanded(
            child: TextField(
              controller: provider.phoneController,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          SvgPicture.asset(MyAssets.edittick),
        ],
      ),
    );
  }
}
