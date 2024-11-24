import 'package:flutter/material.dart';
import 'package:laborus_app/core/model/users/person_model.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:provider/provider.dart';

class InfoProfile extends StatelessWidget {
  final PersonModel? userArgs;

  const InfoProfile({
    super.key,
    this.userArgs,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final PersonModel? displayedUser = userArgs ?? userProvider.user;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayedUser?.name ?? '',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onTertiary,
              fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(
                Icons.school,
                size: Theme.of(context).textTheme.bodyMedium!.fontSize,
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
              const SizedBox(width: 5),
              Text(
                displayedUser?.school ?? 'erro',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
