import 'package:flutter/material.dart';
import 'package:laborus_app/core/model/users/school_model.dart';
import 'package:laborus_app/core/providers/signup_provider.dart';
import 'package:provider/provider.dart';

class InfoInstitutionStep extends StatelessWidget {
  const InfoInstitutionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Informações da Instituição',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).colorScheme.onTertiary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          'Por favor, precisamos de mais algumas informações para criar sua conta.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onTertiary,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 15),
        FutureBuilder<List<SchoolModel>>(
          future: provider.getSchools(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Carregando instituições...',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'Erro ao carregar instituições',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.red,
                          ),
                    ),
                    TextButton(
                      onPressed: () {
                        provider.refreshSchools();
                      },
                      child: Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Nenhuma instituição encontrada',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }

            final schools = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  value: provider.school.isNotEmpty ? provider.school : null,
                  decoration: InputDecoration(
                    labelText: 'Instituição',
                    border: OutlineInputBorder(),
                    errorText: provider.schoolError,
                  ),
                  hint: const Text('Selecione sua instituição'),
                  items: schools.map((school) {
                    return DropdownMenuItem(
                      value: school.id,
                      child: Text(school.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      provider.setSchool(value);
                      provider.setCourse('');
                    }
                  },
                ),
                if (provider.school.isNotEmpty) ...[
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: provider.course.isNotEmpty ? provider.course : null,
                    decoration: InputDecoration(
                      labelText: 'Curso',
                      border: OutlineInputBorder(),
                      errorText: provider.courseError,
                    ),
                    hint: const Text('Selecione seu curso'),
                    items: schools
                        .firstWhere((school) => school.id == provider.school)
                        .courses
                        .map((course) {
                      return DropdownMenuItem(
                        value: course,
                        child: Text(course),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        provider.setCourse(value);
                      }
                    },
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
