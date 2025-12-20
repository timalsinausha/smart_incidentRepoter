import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_incident_repoter/core/api_response.dart';
import 'package:smart_incident_repoter/core/network_status.dart';
import 'package:smart_incident_repoter/service/incidentService/incident_serviceimpl.dart';

final readIncident = Provider<IncidentServiceimpl>((ref){
  return IncidentServiceimpl();
});
final readIncidentControllerProvider =
    StateNotifierProvider<ReadIncidentCOntroller, AsyncValue<Apiresponse>>(
  (ref) {
    final repo = ref.watch(readIncident); // same service
    return ReadIncidentCOntroller(repo);
  },
);


class ReadIncidentCOntroller extends StateNotifier<AsyncValue<Apiresponse>> {
  final IncidentServiceimpl _incidentServiceimpl;

  ReadIncidentCOntroller(this._incidentServiceimpl) : super(AsyncValue.data(Apiresponse(status: NetworkStatus.success)));

  Future<void> readIncidentFromFirebase(String userId) async {
    state = const AsyncValue.loading();
    try {
      final readResponse = await _incidentServiceimpl.readIncident(userId);
      state = AsyncValue.data(readResponse);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}