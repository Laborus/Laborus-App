import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/cards/post_card.dart';
import 'package:laborus_app/core/components/generics/avatar_picture.dart';
import 'package:laborus_app/core/components/generics/base64_image.dart';
import 'package:laborus_app/core/components/list/generic_list_builder_separated.dart';
import 'package:laborus_app/core/providers/discussion_provider.dart';
import 'package:laborus_app/core/providers/post_provider.dart';
import 'package:laborus_app/core/providers/school_provider.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/core/utils/theme/font_size.dart';
import 'package:laborus_app/pages/mobile/scLaborus/campus/widget/create_discussion.dart';
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

class DiscussionTab extends StatefulWidget {
  const DiscussionTab({super.key});

  @override
  State<DiscussionTab> createState() => _DiscussionTabState();
}

class _DiscussionTabState extends State<DiscussionTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final discussionProvider =
          Provider.of<DiscussionProvider>(context, listen: false);
      if (userProvider.user != null) {
        discussionProvider.fetchDiscussions(userProvider.user!.schoolId);
      }
    });
  }

  void _showCreateDiscussionModal() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      useRootNavigator: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CreateDiscussionModal(
        schoolId: userProvider.user!.schoolId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscussionProvider>(
      builder: (context, discussionProvider, child) {
        if (discussionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (discussionProvider.error != null) {
          return Center(
            child: Text(
              'Erro: ${discussionProvider.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (discussionProvider.discussions.isEmpty) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nenhuma discussão disponível',
                  style: TextStyle(
                    fontSize: AppFontSize.large,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                IconButton(
                  onPressed: _showCreateDiscussionModal,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
            top: MediaQuery.of(context).padding.top,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Discussões',
                      style: TextStyle(
                        fontSize: AppFontSize.large,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                    IconButton(
                      onPressed: _showCreateDiscussionModal,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              GenericListBuilderSeparated(
                padding: const EdgeInsets.only(top: 13),
                itemCount: discussionProvider.discussions.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final discussion = discussionProvider.discussions[index];
                  return ListTile(
                    tileColor: Theme.of(context).colorScheme.primary,
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(
                      discussion.title,
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
                            // You might want to add tags logic here
                            Text(
                              discussion
                                  .description, // Replace with actual tags if available
                              style: TextStyle(
                                fontSize: AppFontSize.small,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '•',
                              style: TextStyle(
                                fontSize: AppFontSize.small,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              _calculateTimeAgo(discussion.createdAt),
                              style: const TextStyle(
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
                            if (discussion.isClosed)
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.zero,
                                decoration: const BoxDecoration(
                                  color: AppColors.green,
                                  shape: BoxShape.circle,
                                ),
                                constraints:
                                    BoxConstraints.tight(const Size(28, 28)),
                                child: Icon(
                                  Icons.check,
                                  color: AppColors.neutralsDark[800],
                                  size: AppFontSize.xxxLarge,
                                ),
                              ),
                            TextButton.icon(
                              label: Text(
                                discussion.comments.length
                                    .toString(), // Number of comments
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
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                                size: AppFontSize.xxLarge,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Base64ImageWidget(
                          height: 40,
                          width: 40,
                          base64String: discussion.postedBy.photo ?? '',
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 1);
                },
              )
            ],
          ),
        );
      },
    );
  }

  String _calculateTimeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inHours < 1) {
      return '${difference.inMinutes} min atrás';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else {
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''} atrás';
    }
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
