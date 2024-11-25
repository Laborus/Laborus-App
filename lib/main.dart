import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:laborus_app/core/data/auth_database.dart';
import 'package:laborus_app/core/data/local_database.dart';
import 'package:laborus_app/core/providers/chat_provider.dart';
import 'package:laborus_app/core/providers/image_update_provider.dart';
import 'package:laborus_app/core/providers/jobs_provider.dart';
import 'package:laborus_app/core/providers/post_provider.dart';
import 'package:laborus_app/core/providers/school_provider.dart';
import 'package:laborus_app/core/providers/signin_provider.dart';
import 'package:laborus_app/core/providers/route_stack_provider.dart';
import 'package:laborus_app/core/providers/settings_provider.dart';
import 'package:laborus_app/core/providers/signup_provider.dart';
import 'package:laborus_app/core/providers/student_provider.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/routes/routes.dart';
import 'package:laborus_app/core/services/chat_service.dart';
import 'package:laborus_app/core/services/image_picker_service.dart';
import 'package:laborus_app/core/services/jobs_service.dart';
import 'package:laborus_app/core/services/post_service.dart';
import 'package:laborus_app/core/services/school_service.dart';
import 'package:laborus_app/core/services/user_service.dart';
import 'package:laborus_app/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalDatabase.init();
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['GENERATIVE_API_KEY'];
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
          create: (context) => ImageUpdateProvider(
            ImagePickerService(),
            AuthDatabase(),
            Provider.of<UserProvider>(
              context,
              listen: false,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => PostProvider(PostService()),
        ),
        ChangeNotifierProvider(
          create: (_) => JobsProvider(JobsService()),
        ),
        ChangeNotifierProvider(create: (_) => StudentsProvider()),
        ChangeNotifierProvider(
          create: (context) => SchoolProvider(
            SchoolService(),
            AuthDatabase(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(
            ChatService(apiKey!),
          ),
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
