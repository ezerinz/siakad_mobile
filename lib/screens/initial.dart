import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:siakad_unsulbar/models/mahasiswa_models.dart';
import 'package:siakad_unsulbar/services/api.dart';
import 'package:siakad_unsulbar/ui/app_dialog.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool isLoading = false;

  errorDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Terjadi Kesalahan'),
        content: const Text('Kesalahan terjadi, coba lagi nanti.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school,
                  size: 100.0,
                ),
                SizedBox(
                  height: 70,
                  child: VerticalDivider(
                    thickness: 3,
                    color: Colors.deepPurple,
                  ),
                ),
                Text('SIAKAD',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade400)),
              ],
            ),
            SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: () async {
                  SiakadAPI siakad = SiakadAPI();
                  AppDialog appDialog = AppDialog();
                  appDialog.buildShowDialog(context);
                  try {
                    var login = await siakad.getLogin();
                    if (login['statusCode'] == 302 ||
                        login['statusCode'] == 303) {
                      String namaMhs = await siakad.getName();
                      List<dynamic> alertList = await siakad.getAlert();

                      MahasiswaModels models =
                          MahasiswaModels(name: namaMhs, alertList: alertList);
                      if (context.mounted) {
                        context.goNamed('mahasiswa', extra: models);
                      }
                    } else {
                      if (context.mounted) context.go('/login');
                    }
                    if (context.mounted) Navigator.of(context).pop();
                  } on DioException {
                    Navigator.of(context).pop();
                    appDialog.errorShowDialog(context);
                  }
                },
                child: Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
