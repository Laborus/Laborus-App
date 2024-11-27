import 'package:flutter/material.dart';
import 'package:laborus_app/core/providers/discussion_provider.dart';
import 'package:laborus_app/core/utils/theme/font_size.dart';
import 'package:provider/provider.dart';

class CreateDiscussionModal extends StatefulWidget {
  final String schoolId;

  const CreateDiscussionModal({super.key, required this.schoolId});

  @override
  _CreateDiscussionModalState createState() => _CreateDiscussionModalState();
}

class _CreateDiscussionModalState extends State<CreateDiscussionModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // void _submitDiscussion() {
  //   if (_formKey.currentState!.validate()) {
  //     final discussionProvider =
  //         Provider.of<DiscussionProvider>(context, listen: false);

  //     discussionProvider
  //         .createDiscussion(
  //       schoolId: widget.schoolId,
  //       title: _titleController.text.trim(),
  //       description: _descriptionController.text.trim(),
  //     )
  //         .then((_) {
  //       // Close the modal on successful creation
  //       Navigator.of(context).pop();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscussionProvider>(
      builder: (context, discussionProvider, child) {
        return AbsorbPointer(
          absorbing: discussionProvider.isLoading,
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Criar Nova Discussão',
                    style: TextStyle(
                      fontSize: AppFontSize.large,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Título da Discussão',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: AppFontSize.medium,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, insira um título';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: AppFontSize.medium,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, insira uma descrição';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    // discussionProvider.isLoading ? null : _submitDiscussion,
                    child: discussionProvider.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Criar Discussão'),
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
