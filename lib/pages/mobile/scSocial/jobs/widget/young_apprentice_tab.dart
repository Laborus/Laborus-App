import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/generics/avatar_picture.dart';
import 'package:laborus_app/core/components/list/generic_list_builder_separated.dart';
import 'package:laborus_app/core/components/list/generic_list_tile.dart';
import 'package:laborus_app/core/providers/jobs_provider.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/core/utils/theme/font_size.dart';
import 'package:provider/provider.dart';

class YoungApprenticeTab extends StatelessWidget {
  const YoungApprenticeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsProvider>(
      builder: (context, jobsProvider, child) {
        if (jobsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (jobsProvider.error != null) {
          return Center(child: Text(jobsProvider.error!));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(22),
                child: Row(
                  children: [
                    Text(
                      'Vagas encontradas ',
                      style: TextStyle(
                        fontSize: AppFontSize.xxLarge,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${jobsProvider.totalJobs}',
                      style: TextStyle(
                        fontSize: AppFontSize.xxLarge,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              GenericListBuilderSeparated(
                itemCount: jobsProvider.jobs.length,
                itemBuilder: (context, index) {
                  final job = jobsProvider.jobs[index];
                  return GenericListTile(
                    isThreeLine: true,
                    leading: const AvatarPicture(
                      imagePath: 'assets/img/profile.jpg',
                      size: 40,
                    ),
                    title: job.title,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.work_outline,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: AppFontSize.small,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              job.company.name,
                              style: TextStyle(
                                fontSize: AppFontSize.small,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: AppFontSize.small,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              job.location,
                              style: TextStyle(
                                fontSize: AppFontSize.small,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      padding: const EdgeInsets.all(4),
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      color: AppColors.neutralsLight[0]!,
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onTertiary,
                        size: AppFontSize.xxLarge,
                      ),
                      onPressed: () {},
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
      },
    );
  }
}
