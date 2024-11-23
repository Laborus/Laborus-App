import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/generics/base64_image.dart';
import 'package:laborus_app/core/components/generics/readmore.dart';
import 'package:laborus_app/core/model/laborus/comments.dart';
import 'package:laborus_app/core/model/laborus/post.dart';
import 'package:laborus_app/core/providers/post_provider.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:provider/provider.dart';

class ButtonComment extends StatelessWidget {
  final Post post;

  const ButtonComment({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    void showOptionsBottomSheet() {
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      final user = Provider.of<UserProvider>(context, listen: false).user;
      final TextEditingController commentController = TextEditingController();

      // Carregar comentários
      postProvider.loadComments(post.id!);

      showModalBottomSheet(
        showDragHandle: true,
        isScrollControlled: true,
        enableDrag: true,
        useRootNavigator: true,
        context: context,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * .3,
          maxHeight: MediaQuery.of(context).size.height * .8,
        ),
        builder: (BuildContext context) {
          final comments = postProvider.comments;

          return WillPopScope(
            onWillPop: () async {
              postProvider.clearComments(); // Limpar comentários ao sair
              return true;
            },
            child: SingleChildScrollView(
              dragStartBehavior: DragStartBehavior.start,
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 15),
                          color: Theme.of(context).colorScheme.onPrimary,
                          child: Row(
                            children: [
                              Base64ImageWidget(
                                base64String: user?.profileImage ?? '',
                                width: 50,
                                height: 50,
                                isCircular: true,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: TextField(
                                    controller: commentController,
                                    style: const TextStyle(),
                                    decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      hintText: 'Adicionar comentário...',
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                    onSubmitted: (value) async {
                                      if (value.isNotEmpty) {
                                        try {
                                          await postProvider.addComment(
                                              post.id!,
                                              user?.id ??
                                                  '', // Substituir pelo ID do usuário autenticado
                                              value);
                                          commentController
                                              .clear(); // Limpar o campo de texto
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Erro ao adicionar comentário: $e'),
                                            backgroundColor: Colors.red,
                                          ));
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Consumer<PostProvider>(
                            builder: (context, postProvider, child) {
                          if (postProvider.isLoading) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: AppColors.primaryPurple,
                            ));
                          }
                          return ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: comments.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 13),
                            itemBuilder: (BuildContext context, int index) {
                              Comment comment = comments[index];
                              return ListTile(
                                leading: Base64ImageWidget(
                                  base64String: post.comments?[index].author
                                          .profileImage ??
                                      '',
                                  width: 40,
                                  height: 40,
                                  isCircular: true,
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(comment.author.name),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.school,
                                          size: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiaryContainer,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          comment.author.school ?? '',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiaryContainer,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16)
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ReadMoreText(
                                      comment.content,
                                      trimLines: 3,
                                      textAlign: TextAlign.left,
                                      colorClickableText: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'Ler Mais',
                                      trimExpandedText: 'Mostrar menos',
                                      moreStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Tooltip(
      message: 'comentar',
      child: TextButton.icon(
        onPressed: showOptionsBottomSheet,
        icon: Icon(
          Icons.messenger_outline_rounded,
          color: Theme.of(context).colorScheme.tertiaryContainer,
        ),
        label: Text(
          post.comments?.length.toString() ?? '0',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiaryContainer,
          ),
        ),
      ),
    );
  }
}
