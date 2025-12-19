
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_incident_repoter/core/api_response.dart';
import 'package:smart_incident_repoter/core/network_status.dart';
import 'package:smart_incident_repoter/service/serviceimplements/register_service_impl.dart';

final profileProvider = Provider<RegisterServiceImpl>((ref){
  return RegisterServiceImpl();
});

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<Apiresponse>>(
  (ref) {
    final repo = ref.watch(profileProvider); // same service
    return ProfileController(repo);
  },
);
class ProfileController extends StateNotifier<AsyncValue<Apiresponse>> {
  final RegisterServiceImpl _profileservice;

  ProfileController(this._profileservice) : super(AsyncValue.data(Apiresponse(status: NetworkStatus.success)));

  Future<void> readUserFromFirebase(String email) async {
    state = const AsyncValue.loading();
    try {
      final response = await _profileservice.readUserData(email);
      state = AsyncValue.data(response);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}