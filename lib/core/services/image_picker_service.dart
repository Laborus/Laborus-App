import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:laborus_app/core/data/auth_database.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  final AuthDatabase _authDatabase = AuthDatabase();
  Future<String?> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        final List<int> imageBytes = await imageFile.readAsBytes();
        return base64Encode(imageBytes);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  Future<bool> updateUserImage(
      {required String userId,
      required String base64Image,
      required bool isProfileImage}) async {
    try {
      String? token = await _authDatabase.getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }
      final String url = '${dotenv.env['API_URL']}/api/user/edit/$userId';

      final Map<String, dynamic> body = isProfileImage
          ? {'profileImage': base64Image}
          : {'bannerImage': base64Image};

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(body),
      );
      print(
          'API response status: ${response.statusCode}, body: ${response.body}, token: $token');
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating user image: $e');
      return false;
    }
  }
}
