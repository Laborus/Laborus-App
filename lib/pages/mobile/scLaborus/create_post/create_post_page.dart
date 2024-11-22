import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laborus_app/core/components/generics/base64_image.dart';
import 'package:laborus_app/core/model/laborus/post.dart';
import 'package:laborus_app/core/model/laborus/user.dart';
import 'package:laborus_app/core/model/users/person_model.dart';
import 'package:laborus_app/core/providers/post_provider.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/routes/go_router_prevent_duplicate.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/core/utils/theme/font_size.dart';
import 'package:provider/provider.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

List<String> options = ['Global', 'Campus'];

class _CreatePostPageState extends State<CreatePostPage> {
  String selectedOption = options[0];
  bool commentsEnabled = true;
  String? selectedBase64Image;
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final bytes = await File(image.path).readAsBytes();
        final base64Image = base64Encode(bytes);
        setState(() {
          selectedImage = File(image.path);
          selectedBase64Image =
              base64Image; // Adicione uma variável para armazenar o Base64
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

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

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Câmera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _createPost(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) return;

    if (_titleController.text.isEmpty &&
        _contentController.text.isEmpty &&
        selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione conteúdo ao seu post')),
      );
      return;
    }

    final post = Post(
      user: User(
        id: user.id,
        name: user.name,
        profileImage: user.profileImage,
      ),
      title: _titleController.text,
      text: _contentController.text,
      media: selectedBase64Image ?? '',
      visibility: selectedOption,
    );

    final postProvider = Provider.of<PostProvider>(context, listen: false);

    try {
      if (selectedOption == "Campus") {
        // Replace with actual campus ID.
        final campusId = user.school;
        await postProvider.createPost(post, campusId: campusId);
      } else {
        await postProvider.createPost(post);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post criado com sucesso!')),
      );
      GoRouter.of(context).popAndNavigate(context); // Voltar após sucesso
    } catch (e) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final PersonModel? user = Provider.of<UserProvider>(context).user;
    bool isGlobal = selectedOption == options[0];

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
                    onPressed: () =>
                        GoRouter.of(context).popAndNavigate(context),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onTertiary,
                      size: AppFontSize.xxLarge,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _createPost(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            personInfos(context, isGlobal, user),
            const SizedBox(height: 13),
            TextFormField(
              controller: _titleController,
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
            TextFormField(
              controller: _contentController,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 10,
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
            if (selectedImage != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 21, vertical: 13),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        selectedImage!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => selectedImage = null),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.black.withOpacity(0.5),
                          ),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.only(
          left: 22,
          right: 22,
          top: 13,
          bottom: MediaQuery.of(context).padding.bottom + 13,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _showImagePickerOptions,
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.zero),
                backgroundColor:
                    MaterialStatePropertyAll(AppColors.primaryPurple),
              ),
              icon: Icon(
                Icons.image_outlined,
                color: AppColors.neutralsDark[800]!,
                size: AppFontSize.xxxLarge,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() => commentsEnabled = !commentsEnabled);
              },
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.zero),
                backgroundColor:
                    MaterialStatePropertyAll(AppColors.primaryPurple),
              ),
              icon: Icon(
                commentsEnabled
                    ? Icons.speaker_notes_outlined
                    : Icons.speaker_notes_off_outlined,
                color: AppColors.neutralsDark[800]!,
                size: AppFontSize.xxxLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container personInfos(BuildContext context, bool choose, PersonModel? user) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.symmetric(
        vertical: 17,
        horizontal: 35,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Base64ImageWidget(
            base64String: user?.profileImage ?? '',
            width: 50,
            height: 50,
            isCircular: true,
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user?.name ?? '',
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
