import 'package:flutter/material.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/utils/constants/tags.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:provider/provider.dart';

class EditTagsModal extends StatefulWidget {
  const EditTagsModal({super.key});

  @override
  _EditTagsModalState createState() => _EditTagsModalState();
}

class _EditTagsModalState extends State<EditTagsModal> {
  final List<String> _selectedTags = [];

  void _toggleTag(String tagKey) {
    setState(() {
      if (_selectedTags.contains(tagKey)) {
        _selectedTags.remove(tagKey);
      } else {
        if (_selectedTags.length < 3) {
          print(_selectedTags);
          _selectedTags.add(tagKey.toString());
        }
      }
    });
  }

  void _saveSelectedTags() {
    Provider.of<UserProvider>(context, listen: false)
        .updateUserTags(_selectedTags);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: true,
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 120),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Indicador de arrasto
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Título do modal
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Editar Tags',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Selecione até 3 tags que representam seus interesses',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: tags.length,
                  itemBuilder: (context, index) {
                    final tagKey = tags.keys.elementAt(index);
                    final tagData = tags[tagKey]!;

                    return GestureDetector(
                      onTap: () => _toggleTag(tagKey),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedTags.contains(tagKey)
                              ? tagData['color'].withOpacity(0.2)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: _selectedTags.contains(tagKey)
                                ? tagData['color']
                                : Colors.grey[300]!,
                            width: _selectedTags.contains(tagKey) ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              tagData['icon'],
                              color: _selectedTags.contains(tagKey)
                                  ? tagData['color']
                                  : Colors.grey[600],
                              size: 40,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              tagData['label'],
                              style: TextStyle(
                                color: _selectedTags.contains(tagKey)
                                    ? tagData['color']
                                    : Colors.black87,
                                fontWeight: _selectedTags.contains(tagKey)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed:
                      _selectedTags.isNotEmpty ? _saveSelectedTags : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: AppColors.primaryPurple,
                  ),
                  child: Text(
                    'Salvar Tags (${_selectedTags.length}/3)',
                    style: TextStyle(
                      color: AppColors.neutralsLight[100],
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

extension ShowEditTagsModal on BuildContext {
  void showEditTagsModal() {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EditTagsModal(),
    );
  }
}
