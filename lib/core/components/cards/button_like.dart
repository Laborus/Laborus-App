import 'package:flutter/material.dart';
import 'package:laborus_app/core/model/laborus/post.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/providers/post_provider.dart';

class ButtonLike extends StatelessWidget {
  final Post post;

  const ButtonLike({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final userId = userProvider.user!.id;

    final liked = post.isLikedByUser(userId);

    return Tooltip(
      message: liked ? 'Você já curtiu' : 'Curtir',
      child: TextButton.icon(
        onPressed: liked
            ? null
            : () async {
                await postProvider.toggleLike(post.id!, userId);
              },
        icon: Icon(
          liked
              ? Icons.thumb_up_off_alt_sharp
              : Icons.thumb_up_off_alt_outlined,
          color: liked
              ? AppColors.darknessPurple
              : Theme.of(context).colorScheme.tertiaryContainer,
        ),
        label: Text(
          post.likesCount.toString(),
          style: TextStyle(
            color: liked
                ? AppColors.darknessPurple
                : Theme.of(context).colorScheme.tertiaryContainer,
          ),
        ),
      ),
    );
  }
}
