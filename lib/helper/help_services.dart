import 'package:internet_connection_checker/internet_connection_checker.dart';
class Helper {
  static CheckInternetConnection() async {
    bool result = await InternetConnectionChecker.createInstance().hasConnection;
    return result;
  }

  }