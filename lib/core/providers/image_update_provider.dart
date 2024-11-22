import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laborus_app/core/services/image_picker_service.dart';
import 'package:laborus_app/core/data/auth_database.dart';
import 'package:laborus_app/core/providers/user_provider.dart';

class ImageUpdateProvider extends ChangeNotifier {
  final ImagePickerService _imagePickerService;
  final AuthDatabase _authDatabase;
  final UserProvider _userProvider;

  bool _isLoading = false;
  String? _error;

  ImageUpdateProvider(
      this._imagePickerService, this._authDatabase, this._userProvider);

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> updateProfileImage() async {
    await _updateImage(isProfileImage: true);
  }

  Future<void> updateBannerImage() async {
    await _updateImage(isProfileImage: false);
  }

  Future<void> _updateImage({required bool isProfileImage}) async {
    try {
      _setLoadingState(true);
      _clearError();

      final userId = await _authDatabase.getUserId();
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final base64Image =
          await _imagePickerService.pickImage(ImageSource.gallery);
      if (base64Image == null) {
        throw Exception('Nenhuma imagem selecionada');
      }

      debugPrint(
          'Iniciando atualização de imagem: ${isProfileImage ? 'Perfil' : 'Banner'}');
      debugPrint(
          'Tamanho da imagem em base64: ${base64Image.length} caracteres');

      final success = await _imagePickerService.updateUserImage(
        userId: userId,
        base64Image: base64Image,
        isProfileImage: isProfileImage,
      );

      if (!success) {
        throw Exception(
            'Falha ao atualizar ${isProfileImage ? 'imagem de perfil' : 'banner'}');
      }

      debugPrint('Atualizando imagem no provedor de usuário');
      await _userProvider.refreshUser();

      debugPrint('Imagem atualizada com sucesso');
    } catch (e) {
      debugPrint('Erro ao atualizar imagem: $e');
      _setError(e.toString());
    } finally {
      _setLoadingState(false);
    }
  }

  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
