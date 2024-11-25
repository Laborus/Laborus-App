import 'package:flutter/material.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/core/utils/theme/font_size.dart';
import 'package:laborus_app/pages/mobile/scLaborus/campus/widget/school_info.dart';
import 'package:laborus_app/pages/mobile/scLaborus/campus/widget/tabs.dart';

class CampusScreen extends StatelessWidget {
  const CampusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        appBar: AppBar(
          leadingWidth: double.infinity,
          toolbarHeight: 100,
          leading: const InstitutionInfo(),
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
                text: 'Todas',
              ),
              Tab(
                height: 34,
                text: 'Meu Campus',
              ),
              Tab(
                height: 34,
                text: 'Alertas',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FeedTab(),
            DiscussionTab(),
            AlertsTab(),
          ],
        ),
      ),
    );
  }
}
