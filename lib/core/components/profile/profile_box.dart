import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laborus_app/core/components/generics/base64_image.dart';
import 'package:laborus_app/core/model/users/person_model.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/routes/app_route_enum.dart';
import 'package:provider/provider.dart';

class ProfileBox extends StatelessWidget {
  const ProfileBox({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonModel? user = Provider.of<UserProvider>(context).user;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
      color: Theme.of(context).colorScheme.primary,
      child: GestureDetector(
        onTap: () {
          AppRouteEnum path = AppRouteEnum.profile;
          GoRouter.of(context).pushReplacement(path.name);
        },
        child: Row(
          children: [
            Base64ImageWidget(
              base64String: user?.profileImage ?? '',
              width: 40,
              height: 40,
              defaultImagePath: 'assets/img/pessoa.png',
              isCircular: true,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'teste',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  user?.email ?? 'teste@gmail.com',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
