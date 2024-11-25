import 'package:flutter/material.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String) onSend;

  const ChatInputWidget({required this.onSend, Key? key}) : super(key: key);

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                fillColor: Theme.of(context).colorScheme.secondary,
                hintText: 'Digite sua mensagem...',
                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(9999),
                  ),
                  borderSide: BorderSide(
                    width: 1.5,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primaryPurple,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  widget.onSend(_controller.text.trim());
                  _controller.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
