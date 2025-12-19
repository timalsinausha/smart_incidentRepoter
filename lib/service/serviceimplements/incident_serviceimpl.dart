import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_incident_repoter/core/api_response.dart';
import 'package:smart_incident_repoter/core/network_status.dart';
import 'package:smart_incident_repoter/helper/help_services.dart';
import 'package:smart_incident_repoter/model/incident_model.dart';
import 'package:smart_incident_repoter/service/incident_service.dart';

class IncidentServiceimpl extends IncidentService{
  @override
  Future<Apiresponse> addIncident(Incident incident) async{
      if (await Helper.CheckInternetConnection() == true) {
      try {
        await FirebaseFirestore.instance
            .collection("Incident")
            .add(incident.toJson());
        return Apiresponse(status: NetworkStatus.success);
      } catch (e) {
        return Apiresponse(
            status: NetworkStatus.error, errorMessage: e.toString());
      }
    } else {
      return Apiresponse(
          status: NetworkStatus.error, errorMessage: "no internet connection");
    }
  }

  @override
  Future<Apiresponse> readIncident(String userId) async {
  List<Incident> incidentList = [];
  try {
    var response = await FirebaseFirestore.instance
        .collection("Incident")
        .where('userId', isEqualTo: userId) // only user's incidents
        .get();

    final incidentGet = response.docs;
    if (incidentGet.isNotEmpty) {
      for (var doc in incidentGet) {
        Incident incidentFetch = Incident.fromJson(doc.data());
        incidentFetch.id = doc.id;
        incidentList.add(incidentFetch);
      }
    }
    return Apiresponse(status: NetworkStatus.success, data: incidentList);
  } catch (e) {
    return Apiresponse(
        status: NetworkStatus.error, errorMessage: e.toString());
  }
}

  @override
  Future<Apiresponse> updateIncident(Incident incident)async {
    try {
      await FirebaseFirestore.instance
          .collection("Incident")
          .doc(incident.id)
          .update(incident.toJson());
      return Apiresponse(
        status: NetworkStatus.success,
      );
    } catch (e) {
      return Apiresponse(
          status: NetworkStatus.error, errorMessage: e.toString());
    }
  }
  
  @override
  Future<Apiresponse> deletedIncident(String id)async {
    if (await Helper.CheckInternetConnection() == true) {
      try {
        await FirebaseFirestore.instance.collection("Incident").doc(id).delete();
        return Apiresponse(status: NetworkStatus.success);
      } catch (e) {
        return Apiresponse(
            status: NetworkStatus.error, errorMessage: e.toString());
      }
    } else {
      return Apiresponse(
          status: NetworkStatus.error, errorMessage: "no internet connection");
    }
  }
  
}