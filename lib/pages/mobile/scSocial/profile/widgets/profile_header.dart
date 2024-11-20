import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/profile/profile_banner.dart';
import 'package:laborus_app/core/components/profile/profile_picture.dart';
import 'package:laborus_app/core/model/users/person_model.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  void _editBanner() {}

  void _editProfilePicture() {}

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final PersonModel? user = userProvider.user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          clipBehavior: Clip.none,
          children: [
            ProfileBanner(
              base64Image: user?.bannerImage,
              imagePath: 'assets/img/profile_banner.png',
              onEdit: _editBanner,
            ),
            Positioned(
              left: 22,
              bottom: -47,
              child: ProfilePicture(
                base64Image: user?.profileImage ?? '',
                imagePath: 'assets/img/pessoa.png',
                onEdit: _editProfilePicture,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
