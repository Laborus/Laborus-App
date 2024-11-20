import 'package:flutter/material.dart';
import 'package:laborus_app/core/services/image_picker_service.dart';
import 'package:laborus_app/core/data/auth_database.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpdateProvider extends ChangeNotifier {
  final ImagePickerService _imagePickerService;
  final AuthDatabase _authDatabase;

  bool _isLoading = false;
  String? _error;

  ImageUpdateProvider(this._imagePickerService, this._authDatabase);

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> updateProfileImage() async {
    try {
      _setLoadingState(true);
      _clearError();

      final userId = await _authDatabase.getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final base64Image =
          await _imagePickerService.pickImage(ImageSource.gallery);
      if (base64Image == null) {
        throw Exception('No image selected');
      }

      final success = await _imagePickerService.updateUserImage(
          userId: userId, base64Image: base64Image, isProfileImage: true);

      if (!success) {
        throw Exception('Failed to update profile image');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> updateBannerImage() async {
    try {
      _setLoadingState(true);
      _clearError();

      final userId = await _authDatabase.getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final base64Image =
          await _imagePickerService.pickImage(ImageSource.gallery);
      if (base64Image == null) {
        throw Exception('No image selected');
      }

      final success = await _imagePickerService.updateUserImage(
          userId: userId, base64Image: base64Image, isProfileImage: false);

      if (!success) {
        print('nao foi');
        throw Exception('Failed to update banner image');
      }
      print('foi');
    } catch (e) {
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
