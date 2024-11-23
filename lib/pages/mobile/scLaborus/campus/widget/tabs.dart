import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/cards/post_card.dart';
import 'package:laborus_app/core/components/generics/avatar_picture.dart';
import 'package:laborus_app/core/components/list/generic_list_builder_separated.dart';
import 'package:laborus_app/core/providers/post_provider.dart';
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

class AlertsTab extends StatelessWidget {
  const AlertsTab({super.key});

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
                  'Comunicado Oficial! Suspensão de aulas presenciais devido a falta de água',
                  style: TextStyle(
                    fontSize: AppFontSize.large,
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
                    const Text(
                      '1 hora atrás',
                      style: TextStyle(
                        fontSize: AppFontSize.small,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryPurple,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    TextButton.icon(
                      label: Text(
                        'Urgente',
                        style: TextStyle(
                          fontSize: AppFontSize.medium,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutralsDark[800],
                        ),
                      ),
                      style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.only(
                            left: 8,
                            right: 13,
                            top: 5,
                            bottom: 5,
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          AppColors.red,
                        ),
                      ),
                      onPressed: () {},
                      icon: Icon(
                        Icons.priority_high_rounded,
                        color: AppColors.neutralsDark[800],
                        size: AppFontSize.xxLarge,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      """Prezados Alunos,

Informamos que, devido à falta de água que afeta nossa região, as aulas presenciais na nossa escola estarão suspensas temporariamente. Esta medida é necessária para garantir a segurança e o bem-estar de todos os nossos alunos, professores e funcionários.

Durante o período de suspensão, serão implementadas as seguintes medidas:

Aulas Online: As atividades educacionais continuarão de forma remota. Solicitamos que todos os alunos acessem a plataforma online da escola para acompanhar as aulas e realizar as atividades propostas pelos professores.
Comunicação: Qualquer alteração ou atualização sobre a situação será comunicada por meio dos nossos canais oficiais, incluindo e-mail, site da escola e redes sociais.

Duração: Estamos monitorando a situação de perto e faremos uma nova avaliação para determinar a possibilidade de retorno às aulas presenciais. Contamos com a compreensão de todos e esperamos retomar as atividades normais o mais breve possível.
Pedimos a todos que fiquem atentos às comunicações oficiais da escola e que sigam as orientações de segurança fornecidas pelas autoridades competentes.

Agradecemos a compreensão e a colaboração de todos.
""",
                      style: TextStyle(
                        fontSize: AppFontSize.medium,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiaryContainer,
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
  }
}
