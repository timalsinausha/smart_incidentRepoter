import 'package:smart_incident_repoter/core/api_response.dart';
import 'package:smart_incident_repoter/model/incident_model.dart';

abstract class IncidentService {
   Future<Apiresponse> addIncident(Incident incident);
  Future<Apiresponse> readIncident(String userId);
  Future<Apiresponse> updateIncident(Incident incident);
  Future<Apiresponse> deletedIncident(String id);
}