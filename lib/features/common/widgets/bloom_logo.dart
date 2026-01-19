import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String kBloomLogoAsset = 'assets/logos/navbar_logo.svg';

class BloomLogo extends StatelessWidget {
  const BloomLogo({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Bloom Space logo',
      child: SizedBox(
        width: size,
        height: size,
        child: SvgPicture.asset(
          kBloomLogoAsset,
          fit: BoxFit.contain,
          placeholderBuilder: (context) => Center(
            child: SizedBox(
              width: size * 0.4,
              height: size * 0.4,
              child: const CircularProgressIndicator(strokeWidth: 1.2),
            ),
          ),
        ),
      ),
    );
  }
}
