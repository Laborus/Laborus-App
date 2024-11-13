import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laborus_app/core/components/generics/avatar_picture.dart';
import 'package:laborus_app/core/routes/go_router_prevent_duplicate.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/core/utils/theme/font_size.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

List<String> options = ['Global', 'Campus'];

class _CreatePostPageState extends State<CreatePostPage> {
  String selectedOption = options[0];

  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      useRootNavigator: true,
      showDragHandle: true,
      context: context,
      constraints: const BoxConstraints(
        maxHeight: 260,
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 13,
                    ),
                    child: Text(
                      'Onde deseja publicar?',
                      style: TextStyle(
                        fontSize: AppFontSize.large,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: ListTile(
                      tileColor: AppColors.transparent,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 7,
                      ),
                      leading: Icon(
                        Icons.public,
                        size: AppFontSize.xxxLarge,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Global',
                            style: TextStyle(
                              fontSize: AppFontSize.medium,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          ),
                          Text(
                            'O post será publicado no Feed global do App ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          )
                        ],
                      ),
                      trailing: Radio(
                        activeColor: AppColors.darknessPurple,
                        groupValue: selectedOption,
                        value: options[0],
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value.toString();
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 7,
                      ),
                      leading: Icon(
                        Icons.school,
                        size: AppFontSize.xxxLarge,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Campus',
                            style: TextStyle(
                              fontSize: AppFontSize.medium,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          ),
                          Text(
                            'O post será publicado no Feed do campus',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          )
                        ],
                      ),
                      trailing: Radio(
                        activeColor: AppColors.darknessPurple,
                        groupValue: selectedOption,
                        value: options[1],
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value.toString();
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool choose = selectedOption == options[0];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        elevation: 0,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      GoRouter.of(context).popAndNavigate(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onTertiary,
                      size: AppFontSize.xxLarge,
                    ),
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.all(2),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Text(
                        'Publicar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutralsDark[800]!,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
          ],
        ),
        leadingWidth: double.infinity,
        toolbarHeight: 60,
      ),
      body: Column(
        children: [
          personInfos(context, choose),
          const SizedBox(height: 13),
          TextFormField(
            textAlignVertical: TextAlignVertical.top,
            style: TextStyle(
              fontSize: AppFontSize.xxLarge,
              color: Theme.of(context).colorScheme.onTertiary,
            ),
            cursorColor: Theme.of(context).colorScheme.onTertiary,
            decoration: InputDecoration(
              hintText: 'Título aqui...',
              hintStyle: TextStyle(
                fontSize: AppFontSize.xxLarge,
                color: Theme.of(context).colorScheme.onTertiary,
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 35,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: null,
              expands: true,
              style: TextStyle(
                fontSize: AppFontSize.medium,
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
              cursorColor: Theme.of(context).colorScheme.tertiaryContainer,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: 'Escreva alguma coisa...',
                hintStyle: TextStyle(
                  fontSize: AppFontSize.medium,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 35,
                ),
              ),
            ),
          ),
          const SizedBox(height: 13),
        ],
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.only(
          left: 22,
          right: 22,
          top: 13,
          bottom: MediaQuery.of(context).padding.bottom + 13,
        ),
        child: IconButtonTheme(
          data: IconButtonThemeData(
            style: ButtonStyle(
              iconColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.tertiary),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.all(0),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    AppColors.primaryPurple,
                  ),
                ),
                icon: Icon(
                  Icons.image_outlined,
                  color: AppColors.neutralsDark[800]!,
                  size: AppFontSize.xxxLarge,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.all(0),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    AppColors.primaryPurple,
                  ),
                ),
                icon: Icon(
                  Icons.speaker_notes_off_outlined,
                  color: AppColors.neutralsDark[800]!,
                  size: AppFontSize.xxxLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container personInfos(BuildContext context, bool choose) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.symmetric(
        vertical: 17,
        horizontal: 35,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AvatarPicture(
            imagePath: 'assets/img/profile.jpg',
            size: 50,
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Antonía Martinez',
                style: TextStyle(
                  fontSize: AppFontSize.medium,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
              const SizedBox(height: 3),
              GestureDetector(
                onTap: _showOptionsBottomSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      width: 1,
                      color: AppColors.primaryPurple,
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        choose ? Icons.public : Icons.school,
                        color: AppColors.primaryPurple,
                        size: AppFontSize.medium,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        selectedOption,
                        style: const TextStyle(
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.w500,
                          fontSize: AppFontSize.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
