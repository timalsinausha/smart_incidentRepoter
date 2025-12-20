import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_incident_repoter/core/network_status.dart';
import 'package:smart_incident_repoter/model/credentials.dart';
import 'package:smart_incident_repoter/service/authService/register_service_impl.dart';

import '../../core/api_response.dart';

final registerProvider = Provider<RegisterServiceImpl>((ref){
  return RegisterServiceImpl();
});

final registerControllerProvider = StateNotifierProvider<RegistrationController, AsyncValue<Apiresponse>>((ref){
final repo = ref.watch(registerProvider);
return RegistrationController(repo);
});


final passwordVisibilityProvider = StateProvider<bool>((ref) => true);

class RegistrationController extends StateNotifier<AsyncValue<Apiresponse>>{
  final RegisterServiceImpl _registerServiceImpl;
  RegistrationController(this._registerServiceImpl):super(AsyncValue.data(Apiresponse(status: NetworkStatus.success)));

  Future<void> register(Credential credential) async{
      state = const AsyncValue.loading();
    try {
      final registerResponse = await _registerServiceImpl.registerService(credential);
      state = AsyncValue.data(registerResponse);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final currentUserProvider = StateProvider<Map<String, dynamic>?>((ref) => null);