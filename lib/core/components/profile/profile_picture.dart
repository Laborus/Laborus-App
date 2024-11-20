import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/generics/base64_image.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/core/components/buttons/edit_icon.dart';

class ProfilePicture extends StatelessWidget {
  final String imagePath;
  final String base64Image;
  final VoidCallback onEdit;

  const ProfilePicture({
    super.key,
    required this.imagePath,
    required this.base64Image,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    Widget profileImage;

    profileImage = Base64ImageWidget(
      base64String: base64Image,
      width: 67,
      height: 67,
      fit: BoxFit.cover,
      isCircular: true,
      defaultImagePath: imagePath,
      onTap: onEdit,
    );

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        profileImage,
        Positioned(
          right: -3,
          bottom: -5,
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
