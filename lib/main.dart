import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:laborus_app/core/data/auth_database.dart';
import 'package:laborus_app/core/data/local_database.dart';
import 'package:laborus_app/core/providers/image_update_provider.dart';
import 'package:laborus_app/core/providers/signin_provider.dart';
import 'package:laborus_app/core/providers/route_stack_provider.dart';
import 'package:laborus_app/core/providers/settings_provider.dart';
import 'package:laborus_app/core/providers/signup_provider.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/routes/routes.dart';
import 'package:laborus_app/core/services/image_picker_service.dart';
import 'package:laborus_app/core/services/user_service.dart';
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
          create: (context) => SigninProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SignupProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) {
            final themeProvider = SettingsProvider();
            themeProvider.loadSettings(context);
            return themeProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final userProvider = UserProvider(
              UserService(),
              AuthDatabase(),
            );
            userProvider.initializeUser();
            return userProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final imagePickerService = ImagePickerService();
            final authDatabase = AuthDatabase();
            return ImageUpdateProvider(imagePickerService, authDatabase);
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
      theme: Provider.of<SettingsProvider>(context).themeData,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
