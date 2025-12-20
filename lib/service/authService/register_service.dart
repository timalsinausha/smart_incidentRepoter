
import 'package:smart_incident_repoter/core/api_response.dart';
import 'package:smart_incident_repoter/model/credentials.dart';

abstract class RegisterationService {
  Future<Apiresponse> registerService(Credential credential);
  Future<Apiresponse> loginService(Credential credential);
  Future<Apiresponse> readUserData(String email);
  Future<Apiresponse> profileUpdate(Credential credential);
}