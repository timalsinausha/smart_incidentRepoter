
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_incident_repoter/core/api_response.dart';
import 'package:smart_incident_repoter/core/network_status.dart';
import 'package:smart_incident_repoter/model/credentials.dart';
import 'package:smart_incident_repoter/service/authService/register_service_impl.dart';

final profileUpdateProvider = Provider<RegisterServiceImpl>((ref){
  return RegisterServiceImpl();
});

final profileUpdateControllerProvider =
    StateNotifierProvider<ProfileUpdateController, AsyncValue<Apiresponse>>(
  (ref) {
    final repo = ref.watch(profileUpdateProvider); 
    return ProfileUpdateController(repo);
  },
);
class ProfileUpdateController extends StateNotifier<AsyncValue<Apiresponse>> {
  final RegisterServiceImpl _profileUpdateservice;

  ProfileUpdateController(this._profileUpdateservice) : super(AsyncValue.data(Apiresponse(status: NetworkStatus.success)));

  File? _image;
  String? _imageUrl;

 File? get image => _image;
  String? get imageUrl => _imageUrl;
  // set image picked from UI
  void setImage(File image) {
    _image = image;
  }

  // Upload image to Cloudinary
  Future<void> uploadImageToCloudinary(String cloudinaryUrl, String uploadPreset) async {
    if (_image == null) return;

    state = const AsyncValue.loading();
    try {
      var request = http.MultipartRequest("POST", Uri.parse(cloudinaryUrl));
      request.fields['upload_preset'] = uploadPreset;
      request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(await response.stream.bytesToString());
        _imageUrl = jsonResponse['secure_url']; // uploaded image URL
      } else {
        throw Exception("Image upload failed");
      }
    } catch (e,st) {
      state = AsyncValue.error(e,st);
      rethrow;
    }
  }
  Future<void> updateProfile(Credential credential) async {
    state = const AsyncValue.loading();
    try {
      final response = await _profileUpdateservice.profileUpdate(credential);
      state = AsyncValue.data(response);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}