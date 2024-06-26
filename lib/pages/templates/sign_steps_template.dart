import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laborus_app/core/providers/step_provide.dart';
import 'package:laborus_app/core/utils/routes/global_routes.dart';
import 'package:laborus_app/core/utils/theme/custom/pallet_theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class SignStepsTemplate extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final int maxSteps;

  const SignStepsTemplate({
    super.key,
    required this.navigationShell,
    required this.maxSteps,
  });

  @override
  Widget build(BuildContext context) {
    final int step = Provider.of<StepProvider>(context).stepData;
    final String label = Provider.of<StepProvider>(context).textData;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        toolbarHeight: 200,
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(width: 22),
                IconButton.outlined(
                  padding: const EdgeInsets.all(14),
                  iconSize: 20,
                  style: ButtonStyle(
                    alignment: Alignment.center,
                    side: WidgetStatePropertyAll(
                      BorderSide(color: PalletTheme().neutral600, width: 2),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  onPressed: () {
                    GlobalRouteStack.pop();
                    String previousRoute = GlobalRouteStack.getPreviousRoute();
                    Provider.of<StepProvider>(context, listen: false)
                        .removeData();
                    context.goNamed(previousRoute);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: PalletTheme().neutral600,
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const SizedBox(width: 26),
                CircularPercentIndicator(
                  animateFromLastPercent: true,
                  radius: 40,
                  lineWidth: 5,
                  animation: true,
                  percent: (step.toDouble() / maxSteps.toDouble() > 1)
                      ? 1
                      : step.toDouble() / maxSteps.toDouble(),
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Provider.of<PalletTheme>(context).neutral300,
                  progressColor: Theme.of(context).colorScheme.tertiary,
                  center: Text(
                    "$step de $maxSteps",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.headlineSmall?.fontSize,
                  ),
                )
              ],
            ),
          ],
        ),
        leadingWidth: double.infinity,
      ),
      backgroundColor: PalletTheme().neutral0,
      body: navigationShell,
    );
  }
}
