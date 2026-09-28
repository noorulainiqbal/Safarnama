import 'package:flutter/material.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/utils/size_extension.dart';

class HeroImageSection extends StatelessWidget {
  final String imageUrl;
  const HeroImageSection({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: context.h(370),
      child: ClipRect(
        child: Transform.scale(
          scale: context.w(1.11) / context.w(1),
          child: imageUrl.startsWith('http')
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, ref, trace) => Image.asset(
                    MyAssets.detailsbackground,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
