import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laborus_app/core/routes/go_router_prevent_duplicate.dart';

class CustomAppBarIntroduction extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  const CustomAppBarIntroduction({super.key, required this.title, this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      scrolledUnderElevation: 0,
      foregroundColor: Theme.of(context).colorScheme.primary,
      toolbarHeight: preferredSize.height,
      toolbarOpacity: 1,
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        onPressed: onBack ??
            () => context.canPop()
                ? GoRouter.of(context).popAndNavigate(context)
                : GoRouter.of(context).goNavigate(context, '/'),
        icon: Icon(
          Icons.arrow_back_rounded,
          size: 26,
          color: Theme.of(context).colorScheme.onTertiary,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
