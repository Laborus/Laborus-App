import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laborus_app/core/model/laborus/post.dart';
import 'package:laborus_app/pages/mobile/logic.dart';
import 'package:laborus_app/pages/mobile/scAuth/signin/signin.dart';
import 'package:laborus_app/pages/mobile/scLaborus/campus/campus.dart';
import 'package:laborus_app/pages/mobile/scLaborus/challenge/challenges_page.dart';
import 'package:laborus_app/pages/mobile/scSocial/chat/chat_page.dart';
import 'package:laborus_app/pages/mobile/scLaborus/create_post/create_post_page.dart';
import 'package:laborus_app/pages/mobile/scLaborus/feed/feed_page.dart';
import 'package:laborus_app/pages/mobile/scSocial/connections/connections_page.dart';
import 'package:laborus_app/pages/mobile/scSocial/jobs/jobs_page.dart';
import 'package:laborus_app/pages/mobile/scSocial/notification/notification_view.dart';
import 'package:laborus_app/pages/mobile/scIntroduction/onB/onb_page.dart';
import 'package:laborus_app/pages/mobile/scLaborus/post_full_size/post_full_size_page.dart';
import 'package:laborus_app/pages/mobile/scSocial/profile/profile.dart';
import 'package:laborus_app/pages/mobile/scSettings/settings/settings_page.dart';
import 'package:laborus_app/pages/mobile/scAuth/signup/signup.dart';
import 'package:laborus_app/pages/mobile/scLaborus/templates/home_template.dart';
import 'package:laborus_app/pages/mobile/scIntroduction/welcome/welcome_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _feedNavigatorKey = GlobalKey<NavigatorState>();
final _messageNavigatorKey = GlobalKey<NavigatorState>();
final _settingsNavigatorKey = GlobalKey<NavigatorState>();
final _connectionsNavigatorKey = GlobalKey<NavigatorState>();
final _createNavigatorKey = GlobalKey<NavigatorState>();
final _notificationsNavigatorKey = GlobalKey<NavigatorState>();
final _profileNavigatorKey = GlobalKey<NavigatorState>();
final _schoolNavigatorKey = GlobalKey<NavigatorState>();
final _jobsNavigatorKey = GlobalKey<NavigatorState>();
final _challengesNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'Logic',
      path: '/',
      builder: (context, state) {
        return const LogicPage();
      },
    ),
    GoRoute(
      name: 'Onboarding',
      path: '/onboarding',
      builder: (context, state) {
        return const OnBoardingPage();
      },
    ),
    GoRoute(
      name: 'Welcome',
      path: '/welcome',
      builder: (context, state) {
        return const WelcomePage();
      },
    ),
    GoRoute(
      path: '/feed/post',
      name: 'post',
      builder: (context, state) {
        return PostFullSizePage(
          post: state.extra as Post,
        );
      },
    ),
    GoRoute(
      path: '/signin',
      name: 'Signin',
      builder: (context, state) {
        return const SignInPage();
      },
    ),
    GoRoute(
      path: '/signup',
      name: 'Signup',
      builder: (context, state) {
        return const SignupWrapper();
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeTemplate(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _feedNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              name: 'Home',
              builder: (context, state) {
                return const FeedPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _messageNavigatorKey,
          routes: [
            GoRoute(
              path: '/chat',
              name: 'Chat',
              builder: (context, state) {
                return const ChatPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: [
            GoRoute(
              path: '/settings',
              name: 'Settings',
              builder: (context, state) {
                return const SettingsPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _connectionsNavigatorKey,
          routes: [
            GoRoute(
              path: '/connections',
              name: 'Connections',
              builder: (context, state) {
                return const ConnectionsPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _createNavigatorKey,
          routes: [
            GoRoute(
              path: '/create',
              name: 'create',
              builder: (context, state) {
                return const CreatePostPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
              path: '/profile',
              name: 'Profile',
              builder: (context, state) {
                return const ProfilePage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _notificationsNavigatorKey,
          routes: [
            GoRoute(
              path: '/notification',
              name: 'notification',
              builder: (context, state) {
                return const NotificationPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _schoolNavigatorKey,
          routes: [
            GoRoute(
              path: '/school',
              name: 'school',
              builder: (context, state) {
                return const CampusScreen();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _jobsNavigatorKey,
          routes: [
            GoRoute(
              path: '/job',
              name: 'job',
              builder: (context, state) {
                return const JobsPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _challengesNavigatorKey,
          routes: [
            GoRoute(
              path: '/challenges',
              name: 'challenges',
              builder: (context, state) {
                return const ChallengesPage();
              },
            ),
          ],
        )
      ],
    )
  ],
);

get router => _router;
