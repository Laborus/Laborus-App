import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:laborus_app/data/theme_database.dart';
import 'package:laborus_app/providers/theme_provider.dart';
import 'package:laborus_app/utils/routes/routes.dart';
import 'package:laborus_app/utils/theme/custom/pallet_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  await ThemeDatabase.getTheme();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final themeProvider = ThemeProvider();
            themeProvider.loadTheme();
            return themeProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final palletTheme = PalletTheme();
            palletTheme.init();
            return PalletTheme();
          },
        )
      ],
      child: const LaborusAPP(),
    ),
  );
}

class LaborusAPP extends StatelessWidget {
  const LaborusAPP({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Laborus',
      theme: Provider.of<ThemeProvider>(context).themeData,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
