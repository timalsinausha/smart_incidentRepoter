
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_incident_repoter/core/api_response.dart';
import 'package:smart_incident_repoter/core/network_status.dart';
import 'package:smart_incident_repoter/service/serviceimplements/incident_serviceimpl.dart';

final deleteIncident = Provider<IncidentServiceimpl>((ref){
  return IncidentServiceimpl();
});

final incidentDeleteControllerProvider = StateNotifierProvider<DeleteIncidentController, AsyncValue<Apiresponse>>((ref){
final repo = ref.watch(deleteIncident);
return DeleteIncidentController(repo);
});


class DeleteIncidentController extends StateNotifier<AsyncValue<Apiresponse>> {
  final IncidentServiceimpl _deleteIncidentServiceimpl;
  DeleteIncidentController(this._deleteIncidentServiceimpl) : super( AsyncValue.data(Apiresponse(status: NetworkStatus.success)));
 Future<void> updateIncidentInFirebse(String id) async{
      state = const AsyncValue.loading();
    try {
      final addincidentResponse = await _deleteIncidentServiceimpl.deletedIncident(id);
      state = AsyncValue.data(addincidentResponse);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

}