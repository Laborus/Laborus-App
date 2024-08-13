import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/buttons/text_button_icon.dart';
import 'package:laborus_app/core/components/generics/avatar_picture.dart';
import 'package:laborus_app/core/components/list/generic_list_builder_separated.dart';
import 'package:laborus_app/core/components/list/generic_list_tile.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/core/utils/theme/font_size.dart';
import 'package:laborus_app/pages/mobile/scSocial/connections/dummy_data.dart';

class StudentsTab extends StatelessWidget {
  const StudentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(22),
            child: Text(
              'Estudantes',
              style: TextStyle(
                fontSize: AppFontSize.xxLarge,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
          ),
          GenericListBuilderSeparated(
            itemCount: ConnectionData.students.length,
            itemBuilder: (context, index) {
              final student = ConnectionData.students[index];

              return GenericListTile(
                leading: AvatarPicture(
                  imagePath: student['avatar']!,
                  size: 40,
                ),
                title: student['name']!,
                subtitle: Text(
                  student['location']!,
                  style: TextStyle(
                    fontSize: AppFontSize.small,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: TextButtonIcon(
                  backgroundColor: AppColors.darknessPurple,
                  color: AppColors.neutralsLight[0]!,
                  icon: Icons.person_outlined,
                  label: 'Adicionar',
                  onTap: () {},
                ),
                tileColor: Theme.of(context).colorScheme.primary,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 1),
          ),
        ],
      ),
    );
  }
}
