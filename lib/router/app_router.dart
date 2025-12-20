import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:smart_incident_repoter/model/incident_model.dart';
import 'package:smart_incident_repoter/uiscreens/incidentScreens/details_secreen.dart';
import 'package:smart_incident_repoter/uiscreens/registration/login_screen.dart';
import 'package:smart_incident_repoter/uiscreens/registration/register_screen.dart';
import 'package:smart_incident_repoter/uiscreens/incidentScreens/add_incident_screen.dart';
import 'package:smart_incident_repoter/uiscreens/incidentScreens/home_screen.dart';
import 'package:smart_incident_repoter/uiscreens/userProfile/profile_screen.dart';

class AppRouter {
  static final routerDelegate = BeamerDelegate(locationBuilder: BeamerLocationBuilder(beamLocations: [RegisterLocation(),HomeLocation()]));
  static final routeInformationParser =BeamerParser();
}


class RegisterLocation extends BeamLocation<BeamState>{
  @override
  List<String> get pathPatterns => ['/login', 'register'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      if (state.uri.pathSegments.contains('register'))
      const  BeamPage(
          key: const ValueKey('register'),
          title: 'Register',
          child: RegisterScreen(),
        )
      else
       const BeamPage(
          key: const ValueKey('login'),
          title: 'Login',
          child: LoginScreen(),
        ),
    ];
  }
}

class HomeLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => [
        '/home/readincidents',
        '/home/createincidents',
        '/home/profile',
        '/home/details',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = <BeamPage>[];

    if (state.uri.pathSegments.contains('createincidents')) {
      final editingIncident = state.routeState as Incident?;
      pages.add( BeamPage(
        key: ValueKey('createincidents'),
        title: 'Create Incident',
        child: AddIncidentScreen(editingIncident:editingIncident),
      ));
    } else if (state.uri.pathSegments.contains('profile')) {
      pages.add(const BeamPage(
        key: ValueKey('profile'),
        title: 'Profile',
        child: ProfileScreen(),
      ));
    } else if (state.uri.pathSegments.contains('details')) {
       final detailsIncident = state.routeState as Incident?;
      pages.add(BeamPage(
        key: const ValueKey('details'),
        title: 'Details',
        child: DetailsSecreen(incident:detailsIncident,),
      ));
    } 
    else {
      pages.add(const BeamPage(
        key: ValueKey('readincidents'),
        title: 'Read Incidents',
        child: HomeScreen(),
      ));
    }

    return pages;
  }
}
