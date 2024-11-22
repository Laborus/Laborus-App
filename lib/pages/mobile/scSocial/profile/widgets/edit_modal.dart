import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/forms/text_field_form.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:provider/provider.dart';

class EditAboutModal extends StatefulWidget {
  const EditAboutModal({super.key});

  @override
  _EditAboutModalState createState() => _EditAboutModalState();
}

class _EditAboutModalState extends State<EditAboutModal> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  static const int maxLength = 250;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _controller.text = userProvider.user?.aboutContent ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: _controller,
            maxLines: 4,
            maxLength: maxLength,
            labelText: 'Escreva sobre você',
            onChanged: (value) {
              if (value.length > maxLength) {
                _controller.text = value.substring(0, maxLength);
                _controller.selection = TextSelection.fromPosition(
                  const TextPosition(offset: maxLength),
                );
              }
              setState(() {});
            },
            hintText: 'Escreva sobre você',
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() => _isLoading = true);
                    try {
                      await userProvider.updateAbout(_controller.text);
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao atualizar: $e')),
                      );
                    } finally {
                      setState(() => _isLoading = false);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
