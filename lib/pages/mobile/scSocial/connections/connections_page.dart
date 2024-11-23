import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/forms/input_search.dart';
import 'package:laborus_app/core/components/navigation/custom_appbar_bottom.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/core/utils/theme/font_size.dart';
import 'package:laborus_app/pages/mobile/scSocial/connections/widgets/students_tab.dart';

class ConnectionsPage extends StatelessWidget {
  const ConnectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        appBar: CustomAppBarBottom(
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                const Expanded(child: InputSearch()),
                const SizedBox(width: 13),
                IconButton(
                  icon: const Icon(Icons.tune_rounded),
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  iconSize: AppFontSize.xxxLarge,
                  splashColor: Theme.of(context).colorScheme.secondary,
                  highlightColor: Theme.of(context).colorScheme.secondary,
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.all(12),
                    ),
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          bottom: TabBar(
            dividerColor: Theme.of(context).colorScheme.primary,
            indicatorColor: AppColors.primaryPurple,
            labelColor: AppColors.primaryPurple,
            unselectedLabelColor: Theme.of(context).colorScheme.onSecondary,
            indicatorWeight: 4,
            indicatorSize: TabBarIndicatorSize.tab,
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.only(left: 22),
            isScrollable: true,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              fontSize: AppFontSize.medium,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
              fontSize: AppFontSize.medium,
            ),
            tabs: const [
              Tab(
                height: 34,
                text: 'Estudantes',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            StudentsTab(),
          ],
        ),
      ),
    );
  }
}
