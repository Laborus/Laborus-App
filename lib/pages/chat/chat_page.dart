import 'package:flutter/material.dart';
import 'package:laborus_app/global_widgets/input_search.dart';
import 'package:laborus_app/pages/chat/widgets/group_list.dart';
import 'package:laborus_app/pages/chat/widgets/person_list.dart';
import 'package:laborus_app/utils/constants.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 21, left: 21, right: 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InputSearch(
            margin: 24,
          ),
          const SizedBox(height: 13),
          Text(
            'Grupos',
            style: font(
              Theme.of(context).appBarTheme.foregroundColor,
              FontWeight.w700,
            ).titleMedium,
          ),
          const GroupList(),
          const Expanded(
            child: PersonList(),
          ),
        ],
      ),
    );
  }
}
