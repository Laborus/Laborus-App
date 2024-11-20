import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/forms/dropdown_form_field.dart';
import 'package:laborus_app/core/model/users/school_model.dart';
import 'package:laborus_app/core/providers/signup_provider.dart';
import 'package:provider/provider.dart';

class InfoInstitutionStep extends StatefulWidget {
  const InfoInstitutionStep({super.key});

  @override
  State<InfoInstitutionStep> createState() => _InfoInstitutionStepState();
}

class _InfoInstitutionStepState extends State<InfoInstitutionStep> {
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
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Carregando instituições...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    Icon(Icons.error_outline,
                        color: Theme.of(context).colorScheme.error, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Erro ao carregar instituições',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {}); // This will trigger a rebuild
                      },
                      child: const Text('Tentar novamente'),
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
                CustomDropdownButtonFormField<String>(
                  labelText: 'Instituição',
                  hintText: 'Selecione sua instituição',
                  value: provider.school.isNotEmpty ? provider.school : null,
                  items: schools.map((school) {
                    return DropdownMenuItem(
                      value: school.id,
                      child: Text(
                        school.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      provider.setSchool(value);
                      provider.setCourse('');
                    }
                  },
                  // errorText: provider.schoolError,
                  enabled: true,
                ),
                if (provider.school.isNotEmpty) ...[
                  const SizedBox(height: 15),
                  CustomDropdownButtonFormField<String>(
                    value: provider.course.isNotEmpty ? provider.course : null,
                    labelText: 'Curso',
                    // errorText: provider.courseError,
                    items: schools
                        .firstWhere((school) => school.id == provider.school)
                        .courses
                        .map((course) {
                      return DropdownMenuItem(
                        value: course,
                        child: Text(
                          course,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        provider.setCourse(value);
                      }
                    },
                    hintText: 'Selecione seu curso',
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
