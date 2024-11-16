import 'dart:convert';
import 'package:flutter/material.dart';

class Base64ImageWidget extends StatelessWidget {
  final String base64String;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final String defaultImagePath;
  final BoxFit fit;
  final bool isCircular;
  final VoidCallback? onTap;

  const Base64ImageWidget({
    Key? key,
    required this.base64String,
    this.width,
    this.height,
    this.placeholder,
    this.defaultImagePath = 'assets/img/pessoa.png',
    this.fit = BoxFit.cover,
    this.isCircular = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _buildImage();

    if (isCircular) {
      imageWidget = ClipOval(child: imageWidget);
    }

    return GestureDetector(
      onTap: onTap,
      child: imageWidget,
    );
  }

  Widget _buildImage() {
    try {
      if (base64String.isEmpty) {
        return _buildDefaultImage();
      }

      final imageData = base64Decode(base64String);

      return Image.memory(
        imageData,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultImage();
        },
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: frame != null
                ? child
                : placeholder ?? const CircularProgressIndicator(),
          );
        },
      );
    } catch (e) {
      return _buildDefaultImage();
    }
  }

  Widget _buildDefaultImage() {
    return Image.asset(
      defaultImagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image, size: 50);
      },
    );
  }
}
