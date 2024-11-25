import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/cards/post_card.dart';
import 'package:laborus_app/core/components/generics/avatar_picture.dart';
import 'package:laborus_app/core/components/list/generic_list_builder_separated.dart';
import 'package:laborus_app/core/providers/post_provider.dart';
import 'package:laborus_app/core/providers/school_provider.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/core/utils/theme/font_size.dart';
import 'package:provider/provider.dart';

class FeedTab extends StatefulWidget {
  const FeedTab({super.key});

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false).user;
    final schoolId = userProvider?.schoolId ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostProvider>(context, listen: false)
          .loadCampusPosts(schoolId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, _) {
        return RefreshIndicator(
          onRefresh: () async {
            final userProvider =
                Provider.of<UserProvider>(context, listen: false).user;
            final schoolId = userProvider?.school ?? '';
            await postProvider.loadCampusPosts(schoolId);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
              top: MediaQuery.of(context).padding.top,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (postProvider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (postProvider.postsCampus.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Nenhum post encontrado.',
                        style: TextStyle(fontSize: AppFontSize.medium),
                      ),
                    ),
                  )
                else
                  GenericListBuilderSeparated(
                    padding: const EdgeInsets.only(top: 13),
                    itemCount: postProvider.postsCampus.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PostWidget(post: postProvider.postsCampus[index]);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 13);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DiscussionTab extends StatelessWidget {
  const DiscussionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
        top: MediaQuery.of(context).padding.top,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericListBuilderSeparated(
            padding: const EdgeInsets.only(top: 13),
            itemCount: 1,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                tileColor: Theme.of(context).colorScheme.primary,
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  'Quando a Fatec entregará os ingressos para a Campus Party - CPBR16?',
                  style: TextStyle(
                    fontSize: AppFontSize.medium,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                horizontalTitleGap: 12,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'tags',
                          style: TextStyle(
                            fontSize: AppFontSize.small,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'tags',
                          style: TextStyle(
                            fontSize: AppFontSize.small,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '•',
                          style: TextStyle(
                            fontSize: AppFontSize.small,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 3),
                        const Text(
                          '1 hora atrás',
                          style: TextStyle(
                            fontSize: AppFontSize.small,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryPurple,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.check,
                            color: AppColors.neutralsDark[800],
                            size: AppFontSize.xxxLarge,
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.zero,
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              AppColors.green,
                            ),
                          ),
                          constraints: BoxConstraints.tight(const Size(28, 28)),
                          onPressed: () => {},
                        ),
                        TextButton.icon(
                          label: Text(
                            '21',
                            style: TextStyle(
                              fontSize: AppFontSize.medium,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                            ),
                          ),
                          onPressed: () {},
                          icon: Icon(
                            Icons.chat_bubble_outline,
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            size: AppFontSize.xxLarge,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: const Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AvatarPicture(
                      size: 40,
                      imagePath: 'assets/img/profile.jpg',
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 1);
            },
          ),
        ],
      ),
    );
  }
}

class AlertsTab extends StatefulWidget {
  const AlertsTab({super.key});

  @override
  State<AlertsTab> createState() => _AlertsTabState();
}

class _AlertsTabState extends State<AlertsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final schoolProvider =
          Provider.of<SchoolProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.user != null) {
        schoolProvider.fetchAlerts(userProvider.user!.schoolId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SchoolProvider>(
      builder: (context, schoolProvider, child) {
        if (schoolProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (schoolProvider.error != null) {
          return Center(child: Text(schoolProvider.error!));
        }

        final alerts = schoolProvider.alerts;

        if (alerts.isEmpty) {
          return Center(
              child: Text(
            'Nenhum alerta disponível',
            style: TextStyle(
              fontSize: AppFontSize.large,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onTertiary,
            ),
          ));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
            top: MediaQuery.of(context).padding.top,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GenericListBuilderSeparated(
                padding: const EdgeInsets.only(top: 13),
                itemCount: alerts.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  return ListTile(
                    tileColor: Theme.of(context).colorScheme.primary,
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(
                      alert.title,
                      style: TextStyle(
                        fontSize: AppFontSize.large,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                    horizontalTitleGap: 12,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 5,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTimeAgo(alert.createdAt),
                          style: const TextStyle(
                            fontSize: AppFontSize.small,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryPurple,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 13),
                        TextButton.icon(
                          label: Text(
                            alert.tag,
                            style: TextStyle(
                              fontSize: AppFontSize.medium,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neutralsDark[800],
                            ),
                          ),
                          style: ButtonStyle(
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.only(
                                left: 8,
                                right: 13,
                                top: 5,
                                bottom: 5,
                              ),
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              alert.tag == 'URGENT'
                                  ? AppColors.red
                                  : AppColors.primaryPurple,
                            ),
                          ),
                          onPressed: () {},
                          icon: Icon(
                            alert.tag == 'URGENT'
                                ? Icons.priority_high_rounded
                                : Icons.info_outline,
                            color: AppColors.neutralsDark[800],
                            size: AppFontSize.xxLarge,
                          ),
                        ),
                        const SizedBox(height: 13),
                        Text(
                          alert.text,
                          style: TextStyle(
                            fontSize: AppFontSize.medium,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 13);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} dias atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} horas atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutos atrás';
    } else {
      return 'Agora mesmo';
    }
  }
}
