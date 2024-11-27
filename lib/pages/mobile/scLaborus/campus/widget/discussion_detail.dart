import 'package:flutter/material.dart';
import 'package:laborus_app/core/providers/discussion_provider.dart';
import 'package:provider/provider.dart';

class DiscussionDetailsScreen extends StatefulWidget {
  final String campusId;
  final String discussionId;

  const DiscussionDetailsScreen(
      {Key? key, required this.campusId, required this.discussionId})
      : super(key: key);

  @override
  _DiscussionDetailsScreenState createState() =>
      _DiscussionDetailsScreenState();
}

class _DiscussionDetailsScreenState extends State<DiscussionDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch discussion details after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DiscussionProvider>(context, listen: false)
          .fetchDiscussionDetails(widget.campusId, widget.discussionId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    // if (_commentController.text.trim().isNotEmpty) {
    //   Provider.of<DiscussionProvider>(context, listen: false).addComment(
    //       widget.campusId, widget.discussionId, _commentController.text.trim());
    //   _commentController.clear();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Discussão')),
      body: Consumer<DiscussionProvider>(
        builder: (context, discussionProvider, child) {
          final discussion = discussionProvider.currentDiscussion;

          if (discussionProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (discussion == null) {
            return const Center(child: Text('Discussão não encontrada'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    // Discussion details
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(discussion.title,
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 8),
                          Text(discussion.description,
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 16),
                          Text(
                            'Criado por: ${discussion.postedBy?.name}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    // Comments section
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: discussion.comments?.length,
                      itemBuilder: (context, index) {
                        final comment = discussion.comments?[index];
                        return ListTile(
                          title: Text(comment?.textContent ?? ''),
                          subtitle: Text(comment?.postedBy?.name ?? ''),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Comment input
              if (!discussion.isClosed)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Adicionar comentário...',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _submitComment,
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
