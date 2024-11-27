import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/profile/profile_banner.dart';
import 'package:laborus_app/core/components/profile/profile_picture.dart';
import 'package:laborus_app/core/model/users/person_model.dart';
import 'package:laborus_app/core/providers/image_update_provider.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  final PersonModel? userArgs;

  const ProfileHeader({
    super.key,
    this.userArgs,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final ImageUpdateProvider imageUpdateProvider =
        Provider.of<ImageUpdateProvider>(context);
    final PersonModel? displayedUser = userArgs ?? userProvider.user;
    final bool isCurrentUser = userArgs == null;

    if (imageUpdateProvider.error != null) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              imageUpdateProvider.error!,
            ),
          ),
        );
      });
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (imageUpdateProvider.isLoading) const LinearProgressIndicator(),
        SizedBox(
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              ProfileBanner(
                base64Image: displayedUser?.bannerImage,
                imagePath: 'assets/img/profile_banner.png',
                onEdit: () => imageUpdateProvider.updateBannerImage(),
                isCurrentUser: isCurrentUser,
              ),
              Positioned(
                left: 22,
                bottom: -47,
                child: ProfilePicture(
                  base64Image: displayedUser?.profileImage ?? '',
                  imagePath: 'assets/img/pessoa.png',
                  onEdit: () => imageUpdateProvider.updateProfileImage(),
                  isCurrentUser: isCurrentUser,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
