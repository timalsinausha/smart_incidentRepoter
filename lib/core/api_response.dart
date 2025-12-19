import 'network_status.dart';

class Apiresponse{
   String? errorMessage;
  dynamic data;
  NetworkStatus status;
  Apiresponse({this.data,this.errorMessage,required this.status});
}