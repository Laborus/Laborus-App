import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:laborus_app/core/providers/post_provider.dart';
import 'package:laborus_app/core/components/cards/post_card.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        if (postProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (postProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${postProvider.error}'),
                ElevatedButton(
                  onPressed: () => postProvider.loadPosts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Container(
          color: Theme.of(context).colorScheme.onPrimary,
          child: RefreshIndicator(
            onRefresh: () => postProvider.loadPosts(),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
                top: MediaQuery.of(context).padding.top,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.separated(
                    padding: const EdgeInsets.only(top: 13),
                    itemCount: postProvider.posts.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PostWidget(post: postProvider.posts[index]);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 13);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
