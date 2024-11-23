import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laborus_app/core/components/cards/button_comment.dart';
import 'package:laborus_app/core/components/cards/button_like.dart';
import 'package:laborus_app/core/components/generics/base64_image.dart';
import 'package:provider/provider.dart';
import 'package:laborus_app/core/model/laborus/post.dart';
import 'package:laborus_app/core/components/generics/readmore.dart';

import 'package:laborus_app/core/providers/post_provider.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        return GestureDetector(
          onDoubleTap: () {
            context.goNamed('post', extra: post);
          },
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPostHeader(context),
                const Divider(),
                const SizedBox(height: 13),
                _buildPostContent(context),
                if (post.media.isNotEmpty) ...[
                  const SizedBox(height: 13),
                  _buildPostImage(),
                ],
                const SizedBox(height: 13),
                const Divider(),
                _buildPostActions(context, postProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPostHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 21),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Base64ImageWidget(
                base64String: post.user.profileImage ?? '',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.user.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                  ),
                  const SizedBox(height: 3),
                  if (post.postedByModel == 'Student') ...[
                    Row(
                      children: [
                        Icon(
                          Icons.school,
                          size: 12,
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          post.user.school ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          ' • ',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ],
                  Text(
                    post.timeAgo,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          ReadMoreText(
            post.text,
            trimLines: 3,
            callback: (val) {
              context.goNamed('post', extra: post);
            },
            textAlign: TextAlign.left,
            colorClickableText: Theme.of(context).colorScheme.tertiary,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Ler Mais',
            moreStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Base64ImageWidget(
          base64String: post.media,
          width: double.infinity,
          isCircular: false,
        ),
      ),
    );
  }

  Widget _buildPostActions(BuildContext context, PostProvider postProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 21),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ButtonLike(post: post),
          if (post.commentsEnabled) ButtonComment(post: post),
        ],
      ),
    );
  }
}
