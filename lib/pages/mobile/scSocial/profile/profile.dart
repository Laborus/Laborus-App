import 'package:flutter/material.dart';
import 'package:laborus_app/core/model/users/person_model.dart';
import 'package:laborus_app/pages/mobile/scSocial/profile/widgets/about_section.dart';
import 'package:laborus_app/pages/mobile/scSocial/profile/widgets/post_by_user.dart';
import 'package:laborus_app/pages/mobile/scSocial/profile/widgets/profile_header.dart';
import 'package:laborus_app/pages/mobile/scSocial/profile/widgets/tags_section.dart';
import 'package:laborus_app/pages/mobile/scSocial/profile/widgets/info_profile.dart';

class ProfilePage extends StatelessWidget {
  final PersonModel? userArgs;

  const ProfilePage({
    super.key,
    this.userArgs,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(userArgs: userArgs),
          const SizedBox(height: 66),
          InfoProfile(userArgs: userArgs),
          const SizedBox(height: 13),
          TagsSection(userArgs: userArgs),
          const SizedBox(height: 13),
          AboutSection(userArgs: userArgs),
          const SizedBox(height: 13),
          PostByUser(userArgs: userArgs)
        ],
      ),
    );
  }
}
