import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:laborus_app/core/data/local_database.dart';
import 'package:laborus_app/core/providers/auth_provider.dart';
import 'package:laborus_app/core/providers/route_stack_provider.dart';
import 'package:laborus_app/core/providers/settings_provider.dart';
import 'package:laborus_app/core/routes/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalDatabase.init();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RouteStackProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) {
            final themeProvider = SettingsProvider();
            themeProvider.loadSettings(context);
            return themeProvider;
          },
        ),
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
      theme: Provider.of<SettingsProvider>(context).themeData,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
