import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_incident_repoter/core/api_response.dart';
import 'package:smart_incident_repoter/core/network_status.dart';
import 'package:smart_incident_repoter/helper/help_services.dart';
import 'package:smart_incident_repoter/model/credentials.dart';
import 'package:smart_incident_repoter/service/register_service.dart';

class RegisterServiceImpl extends RegisterationService{
  bool isUserExist = false;

   @override
  Future<Apiresponse> registerService(Credential credential)async {
    if (await Helper.CheckInternetConnection() == true) {
      try {
         final docRef = await FirebaseFirestore.instance
      .collection("Credential")
      .add(credential.toJson());
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
  Future<Apiresponse> loginService(Credential credential) async {
  if (await Helper.CheckInternetConnection() != true) {
    return Apiresponse(
      status: NetworkStatus.error,
      errorMessage: "No internet connection",
    );
  }

  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("Credential")
        .where("email", isEqualTo: credential.email)
        .where("password", isEqualTo: credential.password)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // User exists → get their info
      final userDoc = querySnapshot.docs.first;
      final userData = userDoc.data();
      final userId = userDoc.id; 
      
      return Apiresponse(
        status: NetworkStatus.success,
        data: {
          "id": userId,
          "name": userData['name'],
          "email": userData['email'],
        },
      );
    } else {
      return Apiresponse(
        status: NetworkStatus.error,
        errorMessage: "Invalid credentials",
      );
    }
  } catch (e) {
    return Apiresponse(
      status: NetworkStatus.error,
      errorMessage: e.toString(),
    );
  }
}

  @override
  Future<Apiresponse> readUserData(String email)async {
    Credential? credential;

    try {
      final response = await FirebaseFirestore.instance
          .collection("Credential")
          .where("email", isEqualTo: email)
          .get();

      final credentialdata = response.docs;
      if (credentialdata.isNotEmpty) {
        for (var user in credentialdata) {
          Credential credential1 = Credential.fromJson(user.data());
          credential1.id = user.id;
          credential = credential1;
        }
      }

      return Apiresponse(status: NetworkStatus.success, data: credential);
    } catch (e) {
      return Apiresponse(
          status: NetworkStatus.error, errorMessage: e.toString());
    }
  }
  
  @override
  Future<Apiresponse> profileUpdate(Credential credential)async {
     if (await Helper.CheckInternetConnection() == true) {
      try {
        await FirebaseFirestore.instance
            .collection("Credential")
            .doc(credential.id)
            .update(credential.toJson());
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