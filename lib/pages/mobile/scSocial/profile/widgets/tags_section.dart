import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/chips/edit_tags.dart';
import 'package:laborus_app/core/components/chips/profile_tag.dart';
import 'package:laborus_app/core/model/users/person_model.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/utils/constants/tags.dart';
import 'package:provider/provider.dart';

class TagsSection extends StatelessWidget {
  final PersonModel? userArgs;

  const TagsSection({
    super.key,
    this.userArgs,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final PersonModel? displayedUser = userArgs ?? userProvider.user;
    final userTags = displayedUser?.tags ?? [];
    final bool isCurrentUser = userArgs == null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          ...userTags.map((tagKey) {
            final tagData = tags[tagKey];

            if (tagData == null) {
              return const SizedBox.shrink();
            }
            return ProfileTag(
              iconData: tagData['icon'],
              label: tagData['label'],
              backgroundColor: tagData['color'],
            );
          }).toList(),
          if (isCurrentUser) const EditTags(),
        ],
      ),
    );
  }
}
