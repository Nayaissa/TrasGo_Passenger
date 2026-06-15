import 'package:flutter/material.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/core/functions/build_image_url.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.fallbackIcon = Icons.image_outlined,
    this.backgroundColor,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final IconData fallbackIcon;
  final Color? backgroundColor;

  bool get _isAssetImage {
    final image = imageUrl?.trim() ?? "";
    return image.startsWith("assets/");
  }

  @override
  Widget build(BuildContext context) {
    final image = imageUrl?.trim() ?? "";
    final fullImageUrl = buildImageUrl(imageUrl);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: backgroundColor ?? AppColor.fifthColor,
        child: image.isEmpty
            ? _buildPlaceholder()
            : _isAssetImage
                ? Image.asset(
                    image,
                    width: width,
                    height: height,
                    fit: fit,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder(
                        icon: Icons.broken_image_outlined,
                      );
                    },
                  )
                : Image.network(
                    fullImageUrl,
                    width: width,
                    height: height,
                    fit: fit,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      return const Center(
                        child: SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColor.thirdColor,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder(
                        icon: Icons.broken_image_outlined,
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildPlaceholder({IconData? icon}) {
    return Center(
      child: Icon(
        icon ?? fallbackIcon,
        color: Colors.white38,
        size: 42,
      ),
    );
  }
}