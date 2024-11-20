import 'package:flutter/material.dart';
import 'package:laborus_app/pages/mobile/scSocial/profile/widgets/about_section.dart';
import 'package:laborus_app/pages/mobile/scSocial/profile/widgets/actions_section.dart';
import 'package:laborus_app/pages/mobile/scSocial/profile/widgets/profile_header.dart';
import 'package:laborus_app/pages/mobile/scSocial/profile/widgets/tags_section.dart';
import 'package:laborus_app/pages/mobile/scSocial/profile/widgets/info_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(),
          SizedBox(height: 66),
          InfoProfile(),
          SizedBox(height: 13),
          TagsSection(),
          SizedBox(height: 13),
          AboutSection(),
          SizedBox(height: 13),
          ActionsSection(),
        ],
      ),
    );
  }
}
