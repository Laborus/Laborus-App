import 'package:flutter/material.dart';
import 'package:laborus_app/core/utils/theme/font_size.dart';
import 'package:laborus_app/pages/mobile/scSocial/chat/widgets/person_list.dart';

class PersonsSection extends StatelessWidget {
  const PersonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                Text(
                  'Conversas',
                  style: TextStyle(
                      fontSize: AppFontSize.xxLarge,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onTertiary),
                ),
                // const SizedBox(width: 3),
                // Text(
                //   '${peoples.length}',
                //   style: TextStyle(
                //       fontSize: AppFontSize.xxLarge,
                //       fontWeight: FontWeight.bold,
                //       color: Theme.of(context).colorScheme.tertiary),
                // ),
              ],
            ),
          ),
          const PersonList(),
        ],
      ),
    );
  }
}
