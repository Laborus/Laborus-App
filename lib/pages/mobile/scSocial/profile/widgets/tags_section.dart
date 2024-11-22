import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/chips/edit_tags.dart';
import 'package:laborus_app/core/components/chips/profile_tag.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/utils/constants/tags.dart';
import 'package:provider/provider.dart';

class TagsSection extends StatelessWidget {
  const TagsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userTags = userProvider.user?.tags ?? [];

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
          const EditTags(),
        ],
      ),
    );
  }
}
