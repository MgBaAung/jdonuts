import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:jdonutscodetest/global/app_theme.dart';
import 'package:jdonutscodetest/global/extension/num_extension.dart';
import 'package:jdonutscodetest/global/image_constant.dart';
import 'package:jdonutscodetest/global/extension/text_extension.dart';
import 'package:shimmer/shimmer.dart';

const ink = Color(0xff31241f);
const coral = Color(0xffef6e43);
const cream = Color(0xfffffbf7);
String formatMMK(int value) => value.toString().replaceAllMapped(
  RegExp(r'\B(?=(\d{3})+(?!\d))'),
  (_) => ',',
);

class OfflineImage extends StatelessWidget {
  const OfflineImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    required this.fallback,
  });
  final String asset;
  final double? width, height;
  final BoxFit fit;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    final lowerAsset = asset.toLowerCase();
    if (lowerAsset.endsWith('.jpg') ||
        lowerAsset.endsWith('.jpeg') ||
        lowerAsset.endsWith('.png') ||
        lowerAsset.endsWith('.webp')) {
      return Image.asset(
        asset,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => fallback,
      );
    }
    return SvgPicture.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      placeholderBuilder: (_) => fallback,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}

class CachedImage extends StatelessWidget {
  const CachedImage({
    super.key,
    required this.url,
    required this.fallback,
    this.fallbackAsset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String url;
  final Widget fallback;
  final String? fallbackAsset;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    Widget fallbackImage() {
      final asset = fallbackAsset?.isNotEmpty == true
          ? fallbackAsset!
          : ImageConstant.noproduct;
      return Image.asset(
        asset,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => fallback,
      );
    }

    if (url.isEmpty) return fallbackImage();
    return CachedNetworkImage(
      cacheManager: GetIt.I<CacheManager>(),
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      cacheKey: url.split('?').first,
      useOldImageOnUrlChange: true,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SizedBox(
          width: width,
          height: height,
          child: Container(color: Colors.white),
        ),
      ),
      errorWidget: (context, url, error) => fallbackImage(),
    );
  }
}

class AuthStepScaffold extends StatelessWidget {
  const AuthStepScaffold({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.button,
  });
  final int step;
  final String title, subtitle;
  final Widget child;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    final double progressValue = (step >= 4) ? 1.0 : (step.clamp(1, 4) / 4);

    return Scaffold(
      backgroundColor: const Color(0xfffff3f7),
      appBar: AppBar(
        backgroundColor: const Color(0xfffff3f7),
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 6, bottom: 6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 19,
                color: Color(0xff25232a),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SizedBox(
              width: 28,
              height: 28,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 7.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.cyan.shade200,
                    ),
                  ),
                  CircularProgressIndicator(
                    value: progressValue,
                    strokeWidth: 7.5,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF529D),
                    ),
                  ),
                  step >= 4
                      ? Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF529D),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.check, color: Colors.white),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context
                          .bold(fSize: 22, color: const Color(0xff25232a))
                          .copyWith(height: 1.08),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: context.light(
                          fSize: 12,
                          color: const Color(0xff8d8790),
                        ),
                      ),
                    ],
                    18.height,
                    child,
                  ],
                ),
              ),
            ),
            Padding(padding: [14, 10].symmetricPadding, child: button),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
              child: Text.rich(
                TextSpan(
                  style: context
                      .light(fSize: 9, color: const Color(0xff9a929a))
                      .copyWith(height: 1.4),
                  children: const [
                    TextSpan(
                      text: 'By continuing, you acknowledge that you have read and agree to our ',
                    ),
                    TextSpan(
                      text: 'Terms of Use',
                      style: TextStyle(color: Color(0xffe85d99)),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(color: Color(0xffe85d99)),
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 54,
    child: FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: coral,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 48,
    child: FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xff50c9df),
        disabledBackgroundColor: const Color(0xffbcecf3),
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
      ),
      onPressed: onTap,
      child: Builder(
        builder: (context) => Text(
          text.toUpperCase(),
          style: context
              .medium(fSize: 12, color: Colors.white)
              .copyWith(letterSpacing: .8, fontWeight: FontWeight.w800),
        ),
      ),
    ),
  );
}

class DonutIllustration extends StatelessWidget {
  const DonutIllustration({super.key, required this.size});
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: DonutPainter()),
  );
}

class DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final center = Offset(s.width / 2, s.height / 2);
    final r = s.shortestSide * .43;
    canvas.drawCircle(center, r, Paint()..color = const Color(0xffd99654));
    canvas.drawCircle(
      center,
      r * .70,
      Paint()..color = const Color(0xffffdfb5),
    );
    canvas.drawCircle(center, r * .27, Paint()..color = cream);
    final glaze = Paint()..color = const Color(0xfff28a8a);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r * .77),
      -.5,
      4.8,
      false,
      glaze
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * .18
        ..strokeCap = StrokeCap.round,
    );
    for (var i = 0; i < 9; i++) {
      final a = i * 2 * math.pi / 9;
      canvas.drawCircle(
        center + Offset(math.cos(a) * r * .86, math.sin(a) * r * .86),
        s.width * .018,
        Paint()..color = i.isEven ? Colors.white : const Color(0xff7f4c38),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
