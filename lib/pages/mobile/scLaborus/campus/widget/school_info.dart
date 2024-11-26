import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/generics/base64_image.dart';
import 'package:provider/provider.dart';
import 'package:laborus_app/core/providers/school_provider.dart';
import 'package:laborus_app/core/providers/user_provider.dart';

class InstitutionInfo extends StatefulWidget {
  const InstitutionInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<InstitutionInfo> createState() => _InstitutionInfoState();
}

class _InstitutionInfoState extends State<InstitutionInfo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSchoolData();
    });
  }

  Future<void> _initializeSchoolData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final schoolProvider = Provider.of<SchoolProvider>(context, listen: false);

    final user = userProvider.user;
    if (user != null) {
      await schoolProvider.initializeSchool(user.schoolId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SchoolProvider>(
      builder: (context, schoolProvider, child) {
        if (schoolProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final school = schoolProvider.school;
        if (school == null) {
          return const SizedBox.shrink();
        }

        final totalStudents = school.followers.length.toString();

        final onlineStudents = school.isOnline
            ? (school.followers.length * 0.1)
                .round()
                .toString() // exemplo: 10% dos alunos
            : "0";

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Base64ImageWidget(
                base64String: school.profileImage,
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      school.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          school.location.isNotEmpty
                              ? school.location
                              : 'Localização não definida',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.school_outlined,
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              size: 14,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '$totalStudents alunos',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     Container(
                        //       width: 10,
                        //       height: 10,
                        //       decoration: BoxDecoration(
                        //         color: school.isOnline
                        //             ? AppColors.green
                        //             : Colors.grey,
                        //         shape: BoxShape.circle,
                        //       ),
                        //     ),
                        //     const SizedBox(width: 3),
                        //     // Text(
                        //     //   '$onlineStudents on-line',
                        //     //   style: TextStyle(
                        //     //     fontSize: 14,
                        //     //     color: Theme.of(context)
                        //     //         .colorScheme
                        //     //         .tertiaryContainer,
                        //     //   ),
                        //     // ),
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
