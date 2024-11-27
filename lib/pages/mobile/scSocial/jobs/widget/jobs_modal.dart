import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/chips/profile_tag.dart';
import 'package:laborus_app/core/components/generics/avatar_picture.dart';
import 'package:laborus_app/core/components/generics/text_app.dart';
import 'package:laborus_app/core/model/social/job.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/core/utils/theme/font_size.dart';
import 'package:laborus_app/core/utils/constants/tags.dart'; // Assuming you have a tags constant file

class JobDetailModal extends StatelessWidget {
  final Job job;

  const JobDetailModal({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize:
              MainAxisSize.min, // Ajusta a altura do conteúdo dinamicamente
          children: [
            // Job Header
            Row(
              children: [
                AvatarPicture(
                  imagePath: 'assets/img/company.png',
                  size: 48,
                ),
                const SizedBox(width: 16),
                Divider(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextApp(
                        label: job.title,
                        fontSize: AppFontSize.large,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                      const SizedBox(height: 4),
                      TextApp(
                        label: job.company.name,
                        fontSize: AppFontSize.medium,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextApp(
              label: job.timeAgo,
              fontSize: AppFontSize.xLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryPurple,
            ),
            const SizedBox(height: 16),

            // Job Details
            _buildDetailRow(context, Icons.location_on_outlined, job.location),
            const SizedBox(height: 16),
            _buildDetailRow(context, Icons.schedule, job.period),
            const SizedBox(height: 16),
            _buildDetailRow(context, Icons.work_outline, job.modality),
            const SizedBox(height: 24),

            // Job Description
            TextApp(
              label: job.description,
              fontSize: AppFontSize.medium,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onTertiary,
            ),
            const SizedBox(height: 24),

            // Job Tags
            _buildJobTags(context),
            const SizedBox(height: 24),

            // Apply Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement job application logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darknessPurple,
                    foregroundColor: AppColors.darknessPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Candidatar-se',
                    style: TextStyle(
                      fontSize: AppFontSize.medium,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build detail rows
  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.tertiary,
          size: AppFontSize.medium,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextApp(
            label: text,
            fontSize: AppFontSize.medium,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildJobTags(BuildContext context) {
    final jobTags = job.tags ?? [];

    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 8.0,
      runSpacing: 8.0,
      children: jobTags.map((tagKey) {
        final tagData = tags[tagKey];

        if (tagData == null) {
          return const SizedBox.shrink();
        }

        return ProfileTag(
          label: tagData['label'],
          iconData: tagData['icon'],
          backgroundColor: tagData['color'],
        );
      }).toList(),
    );
  }
}
