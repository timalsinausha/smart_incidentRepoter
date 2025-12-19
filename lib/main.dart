import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_incident_repoter/router/app_router.dart';

import 'firebase_options.dart';

void main()async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child:MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: AppRouter.routerDelegate,
      routeInformationParser: AppRouter.routeInformationParser,
      title: 'Smart Incident Reporter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: LoginScreen(),
    );
  }

  //  @override
  // Widget build(BuildContext context) {
  //   return BeamerProvider(
  //     routerDelegate: AppRouter.routerDelegate,
  //     child: MaterialApp.router(
  //       routerDelegate: AppRouter.routerDelegate,
  //       routeInformationParser: AppRouter.routeInformationParser,
  //       builder: (context, child) {
  //         return Scaffold(
  //           body: child, // Beamer navigator
  //           bottomNavigationBar: BottomNavigationBar(
  //             currentIndex: _calculateIndex(context),
  //             onTap: (index) => _onTap(context, index),
  //             items: const [
  //               BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Read'),
  //               BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Create'),
  //               BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // int _calculateIndex(BuildContext context) {
  //   final path = Beamer.of(context).currentConfiguration?.uri.path ?? '';
  //   if (path.contains('createincidents')) return 1;
  //   if (path.contains('profile')) return 2;
  //   return 0;
  // }

  // void _onTap(BuildContext context, int index) {
  //   switch (index) {
  //     case 0:
  //       Beamer.of(context).beamToNamed('/home/readincidents');
  //       break;
  //     case 1:
  //       Beamer.of(context).beamToNamed('/home/createincidents');
  //       break;
  //     case 2:
  //       Beamer.of(context).beamToNamed('/home/profile');
  //       break;
  //   }
  // }

}
