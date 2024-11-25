import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laborus_app/core/components/list/generic_list_builder_separated.dart';
import 'package:laborus_app/core/components/list/generic_list_tile.dart';
import 'package:laborus_app/pages/mobile/scSocial/chat/data/dummy_data.dart';
import 'package:laborus_app/core/model/social/people.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/core/utils/theme/font_size.dart';
import 'package:laborus_app/core/components/generics/avatar_picture.dart';
import 'package:go_router/go_router.dart';

class PersonList extends StatelessWidget {
  const PersonList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<People> updatedPeoples = [
      People(
        id: 'lia',
        name: 'LIA - Assistente Virtual',
        image: 'assets/images/lia_avatar.png',
        lastVisited: DateTime.now(),
        viewed: true,
      ),
      ...peoples,
    ];

    return GenericListBuilderSeparated(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      shrinkWrap: true,
      itemCount: updatedPeoples.length,
      itemBuilder: (context, index) {
        final People people = updatedPeoples[index];
        return GestureDetector(
          onTap: () {
            if (people.id == 'lia') {
              context.push('/chat/LIA');
            } else {
              // Do nothing for other items
            }
          },
          child: GenericListTile(
            leading: AvatarPicture(
              imagePath: people.image,
              size: 50,
            ),
            title: people.name,
            subtitle: Text(
              people.name,
              style: TextStyle(
                fontSize: AppFontSize.small,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat.jm().format(people.lastVisited),
                  style: TextStyle(
                    fontSize: AppFontSize.small,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                ),
                const SizedBox(height: 3),
                Icon(
                  Icons.done_all_rounded,
                  size: AppFontSize.xLarge,
                  color: people.viewed
                      ? AppColors.primaryPurple
                      : Theme.of(context).colorScheme.tertiaryContainer,
                ),
              ],
            ),
            tileColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 1),
    );
  }
}
