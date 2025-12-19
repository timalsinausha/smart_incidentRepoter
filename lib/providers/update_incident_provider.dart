import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_incident_repoter/core/api_response.dart';
import 'package:smart_incident_repoter/core/network_status.dart';
import 'package:smart_incident_repoter/model/incident_model.dart';
import 'package:smart_incident_repoter/service/serviceimplements/incident_serviceimpl.dart';

final updateIncident = Provider<IncidentServiceimpl>((ref){
  return IncidentServiceimpl();
});

final incidentUpdateControllerProvider = StateNotifierProvider<UpdateIncidentController, AsyncValue<Apiresponse>>((ref){
final repo = ref.watch(updateIncident);
return UpdateIncidentController(repo);
});


class UpdateIncidentController extends StateNotifier<AsyncValue<Apiresponse>> {
  final IncidentServiceimpl _updateIncidentServiceimpl;
  UpdateIncidentController(this._updateIncidentServiceimpl) : super( AsyncValue.data(Apiresponse(status: NetworkStatus.success)));
 Future<void> updateIncidentInFirebse(Incident incident) async{
      state = const AsyncValue.loading();
    try {
      final addincidentResponse = await _updateIncidentServiceimpl.updateIncident(incident);
      state = AsyncValue.data(addincidentResponse);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

}