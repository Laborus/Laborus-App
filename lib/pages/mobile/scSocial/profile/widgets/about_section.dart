import 'package:flutter/material.dart';
import 'package:laborus_app/core/model/users/person_model.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/core/utils/theme/font_size.dart';
import 'package:laborus_app/pages/mobile/scSocial/profile/widgets/edit_modal.dart';
import 'package:laborus_app/pages/mobile/scSocial/profile/widgets/section_content.dart';
import 'package:laborus_app/pages/mobile/scSocial/profile/widgets/section_tile.dart';
import 'package:provider/provider.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});
  void showEditModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Para ajustar à altura do teclado
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const EditAboutModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final PersonModel? user = userProvider.user;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(title: 'Sobre'),
                const SizedBox(height: 8),
                SectionContent(
                  content: user?.aboutContent ?? 'teste',
                ),
                const SizedBox(height: 13),
                const SectionTitle(title: 'Curso'),
                const SizedBox(height: 8),
                SectionContent(
                  content: user?.course.toLowerCase() ?? 'teste',
                ),
              ],
            ),
          ),
          Positioned(
            top: -5,
            right: -5,
            child: editButton(
              onTap: () => showEditModal(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget editButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryPurple,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Icon(
          Icons.edit_outlined,
          size: AppFontSize.medium,
          color: AppColors.neutralsDark[800]!,
        ),
      ),
    );
  }
}
