import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laborus_app/core/data/auth_database.dart';
import 'package:laborus_app/core/data/local_database.dart';
import 'package:laborus_app/core/routes/app_route_enum.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';

class LogicPage extends StatefulWidget {
  const LogicPage({super.key});

  @override
  State<LogicPage> createState() => _LogicPageState();
}

class _LogicPageState extends State<LogicPage> {
  @override
  void initState() {
    super.initState();
    _checkTokenStatus();
  }

  Future<void> _checkTokenStatus() async {
    final authDatabase = AuthDatabase();
    final isValidToken = await authDatabase.validateToken();
    final onboardingShown = await LocalDatabase.isOnboardingShown();
    final id = await authDatabase.getUserId();
    print(
        'isValidToken: $isValidToken, id: $id, onboardingShown: $onboardingShown');
    if (!onboardingShown) {
      if (mounted) {
        final routePath = AppRouteEnum.onboarding.name;
        context.go(routePath);
      }
    } else if (isValidToken && id != null) {
      if (mounted) {
        final routePath = AppRouteEnum.home.name;
        context.go(routePath);
      }
    } else {
      if (mounted) {
        final routePath = AppRouteEnum.welcome.name;
        context.go(routePath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.darknessPurple,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
