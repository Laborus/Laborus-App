import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laborus_app/core/data/global_vars.dart';
import 'package:laborus_app/core/components/list/option_tile.dart';
import 'package:laborus_app/core/components/profile/profile_box.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/routes/app_route_enum.dart';
import 'package:laborus_app/core/routes/go_router_prevent_duplicate.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const ProfileBox(),
          const Divider(),
          ListView(
            physics: const ClampingScrollPhysics(),
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            shrinkWrap: true,
            children: [
              const Option(
                icon: Icons.wb_sunny_outlined,
                text: 'Aparência',
                isSwitch: true,
                isThemeSwitch: true,
              ),
              const Option(
                icon: Icons.notifications_on_outlined,
                text: 'Notificações',
                isSwitch: true,
                isThemeSwitch: false,
              ),
              const Option(
                icon: Icons.gpp_maybe_outlined,
                text: 'Política de Privacidade',
                isSwitch: false,
              ),
              const Option(
                icon: Icons.description_outlined,
                text: 'Termos de Uso',
                isSwitch: false,
              ),
              const Option(
                icon: Icons.help_outline,
                text: 'Ajuda & Suporte',
                isSwitch: false,
              ),
              const Option(
                icon: Icons.smartphone_rounded,
                text: 'Versão ${AppGlobals.versionApp}',
                isSwitch: false,
              ),
              Option(
                icon: Icons.logout_rounded,
                text: 'Sair da Conta',
                isSwitch: false,
                isSignOut: true,
                callback: () {
                  context.read<UserProvider>().destroyUserData();
                  AppRouteEnum path = AppRouteEnum.welcome;
                  GoRouter.of(context)
                      .clearStackAndNavigate(context, path.name);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
