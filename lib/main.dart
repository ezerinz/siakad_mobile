import 'package:flutter/material.dart';
import 'package:siakad_unsulbar/models/mahasiswa_models.dart';
import 'package:siakad_unsulbar/screens/mahasiswa.dart';
import 'package:siakad_unsulbar/screens/login.dart';
import 'package:siakad_unsulbar/screens/initial.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => InitialScreen(), routes: [
      GoRoute(
        path: 'login',
        builder: (context, state) => MyLogin(),
        /*redirect: (BuildContext context, GoRouterState state) async {
          SiakadAPI siakad = SiakadAPI();
          var login = await siakad.getLogin();
          if (login['statusCode'] == 302 || login['statusCode'] == 303) {
            return '/mahasiswa';
          } else {
            return null;
          }
        },*/
      ),
      GoRoute(
          name: "mahasiswa",
          path: 'mahasiswa',
          builder: (context, state) {
            MahasiswaModels models = state.extra as MahasiswaModels;
            return Mahasiswa(object: models);
          }),
    ]),
  ],
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SIAKAD UNSULBAR',
      theme: ThemeData(
          useMaterial3: true,
          iconTheme: IconThemeData(color: Colors.deepPurple.shade400),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple.shade400)),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurple.shade400)),
      routerConfig: _router,
    );
  }
}
