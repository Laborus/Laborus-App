import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laborus_app/core/components/buttons/text_button_icon.dart';
import 'package:laborus_app/core/components/generics/base64_image.dart';
import 'package:laborus_app/core/components/list/generic_list_builder_separated.dart';
import 'package:laborus_app/core/components/list/generic_list_tile.dart';
import 'package:laborus_app/core/providers/student_provider.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/core/utils/theme/font_size.dart';
import 'package:provider/provider.dart';

class StudentsTab extends StatelessWidget {
  const StudentsTab({super.key});
  void navigateToProfile(BuildContext context, String userId) {
    GoRouter.of(context).pushNamed(
      'Profile',
      queryParameters: {'userId': userId},
    );
  }

  Future<void> _handleConnectionRequest(
      BuildContext context, String studentId) async {
    try {
      final studentsProvider = context.read<StudentsProvider>();
      await studentsProvider.sendConnectionRequest(studentId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitação enviada com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar solicitação: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Load students when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentsProvider>().processBatchConnections();
    });

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
          Consumer<StudentsProvider>(
            builder: (context, studentsProvider, child) {
              if (studentsProvider.isLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (studentsProvider.error != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'Erro ao carregar estudantes: ${studentsProvider.error}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => studentsProvider.loadStudents(),
                          child: const Text('Tentar Novamente'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (studentsProvider.students.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Nenhum estudante encontrado',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onTertiary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }

              return GenericListBuilderSeparated(
                itemCount: studentsProvider.students.length,
                itemBuilder: (context, index) {
                  final student = studentsProvider.students[index];

                  return GenericListTile(
                    leading: GestureDetector(
                      onTap: () => navigateToProfile(context, student.id),
                      child: Base64ImageWidget(
                        base64String: student.profileImage,
                        width: 40,
                        height: 40,
                      ),
                    ),
                    title: student.name,
                    subtitle: Text(
                      student.school ?? '',
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
                      onTap: () =>
                          _handleConnectionRequest(context, student.id),
                    ),
                    tileColor: Theme.of(context).colorScheme.primary,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 1),
              );
            },
          ),
        ],
      ),
    );
  }
}
