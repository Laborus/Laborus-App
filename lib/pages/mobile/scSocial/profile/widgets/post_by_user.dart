import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/cards/post_card.dart';
import 'package:laborus_app/core/components/list/generic_list_builder_separated.dart';
import 'package:laborus_app/core/providers/post_provider.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/utils/theme/font_size.dart';
import 'package:provider/provider.dart';

class PostByUser extends StatefulWidget {
  const PostByUser({super.key});

  @override
  State<PostByUser> createState() => _PostByUserState();
}

class _PostByUserState extends State<PostByUser> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final postProvider = Provider.of<PostProvider>(context, listen: false);

      final userId = userProvider.user?.id ?? '';
      if (userId.isNotEmpty) {
        postProvider.loadUserPosts(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Consumer<PostProvider>(
      builder: (context, postProvider, _) {
        final user = userProvider.user;
        final userId = user?.id ?? '';

        return RefreshIndicator(
          onRefresh: () async {
            await postProvider.loadUserPosts(userId);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (postProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (postProvider.userPosts.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Nenhum post encontrado.',
                      style: TextStyle(
                        fontSize: AppFontSize.medium,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  ),
                )
              else
                GenericListBuilderSeparated(
                  padding: const EdgeInsets.only(top: 13, bottom: 24),
                  itemCount: postProvider.userPosts.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return PostWidget(post: postProvider.userPosts[index]);
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
}
