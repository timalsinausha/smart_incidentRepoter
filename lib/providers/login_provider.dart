
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_incident_repoter/core/api_response.dart';
import 'package:smart_incident_repoter/core/network_status.dart';
import 'package:smart_incident_repoter/model/credentials.dart';
import 'package:smart_incident_repoter/service/serviceimplements/register_service_impl.dart';

final registerProvider = Provider<RegisterServiceImpl>((ref){
  return RegisterServiceImpl();
});

final loginControllerProvider =
    StateNotifierProvider<LoginController, AsyncValue<Apiresponse>>(
  (ref) {
    final repo = ref.watch(registerProvider); // same service
    return LoginController(repo);
  },
);

final loginPasswordVisibilityProvider = StateProvider<bool>((ref) => true);
class LoginController extends StateNotifier<AsyncValue<Apiresponse>> {
  final RegisterServiceImpl _service;

  LoginController(this._service) : super(AsyncValue.data(Apiresponse(status: NetworkStatus.success)));

  Future<void> login(Credential credential) async {
    state = const AsyncValue.loading();
    try {
      final response = await _service.loginService(credential);
      state = AsyncValue.data(response);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}