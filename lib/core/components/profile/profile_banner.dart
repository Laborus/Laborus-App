import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/generics/base64_image.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/core/components/buttons/edit_icon.dart';

class ProfileBanner extends StatelessWidget {
  final String? imagePath;
  final String? base64Image;
  final VoidCallback onEdit;
  final bool isCurrentUser;

  const ProfileBanner({
    super.key,
    this.imagePath,
    this.base64Image,
    required this.onEdit,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    Widget bannerImage;

    bannerImage = Base64ImageWidget(
      base64String: base64Image ?? '',
      width: double.infinity,
      height: 162,
      fit: BoxFit.cover,
      defaultImagePath: imagePath!,
      isCircular: false,
    );

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        SizedBox(
          height: 162,
          width: double.infinity,
          child: bannerImage,
        ),
        if (isCurrentUser)
          Positioned(
            right: 22,
            bottom: 5,
            child: EditIcon(
              onTap: onEdit,
              color: AppColors.primaryPurple,
              iconColor: AppColors.neutralsDark[800]!,
            ),
          ),
      ],
    );
  }
}
