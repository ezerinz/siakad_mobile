import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:siakad_unsulbar/models/mahasiswa_models.dart";
import "package:siakad_unsulbar/services/api.dart";
import "package:siakad_unsulbar/ui/app_dialog.dart";

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  SiakadAPI siakad = SiakadAPI();
  String captchaKey = "";

  final _formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController captchaController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
          child: Container(
              padding:
                  EdgeInsets.only(top: 10.0, left: 20, right: 20, bottom: 0.2),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school,
                            size: 70.0,
                          ),
                          Text(
                            'SIAKAD',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade400),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        controller: userController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                          hintText: 'Username',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username harus diisi.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      StatefulBuilder(builder: (context, setState) {
                        void toggle() {
                          setState(() => obscureText = !obscureText);
                        }

                        return TextFormField(
                            controller: passwordController,
                            obscureText: obscureText,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                    onPressed: toggle,
                                    icon: obscureText
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility)),
                                labelText: 'Password',
                                hintText: 'Password'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password harus diisi.';
                              }
                              return null;
                            });
                      }),
                      const SizedBox(
                        height: 15.0,
                      ),
                      const Text(
                        'Kode Captcha',
                        style: TextStyle(fontSize: 12),
                      ),
                      StatefulBuilder(builder: (context, setState) {
                        return Row(children: [
                          FutureBuilder(
                              future: siakad.getCaptcha(),
                              builder: (context,
                                  AsyncSnapshot<Map<String, String>> snapshot) {
                                var data = snapshot.data;
                                if (data != null && data['src'] != null) {
                                  captchaKey = data['key']!;
                                  return Expanded(
                                      child: Image.network(data['src']!));
                                } else {
                                  return Expanded(
                                      child: ColoredBox(
                                    color: Color(0xFF455A64),
                                    child: Placeholder(
                                      fallbackHeight: 65.0,
                                    ),
                                  ));
                                }
                              }),
                          IconButton(
                              onPressed: () => setState(() {}),
                              icon: Icon(Icons.refresh))
                        ]);
                      }),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                          controller: captchaController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Captcha'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Isi captcha.';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 10.0,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            AppDialog().buildShowDialog(context);
                            var login = await siakad.getLogin(
                                user: userController.text,
                                password: passwordController.text,
                                captchaKey: captchaKey,
                                captcha: captchaController.text);

                            if (login['statusCode'] == 302 ||
                                login['statusCode'] == 303) {
                              String namaMhs = await siakad.getName();
                              List<dynamic> alertList = await siakad.getAlert();

                              MahasiswaModels models = MahasiswaModels(
                                  name: namaMhs, alertList: alertList);
                              if (context.mounted) {
                                context.goNamed('mahasiswa', extra: models);
                              }
                              ;
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context).pop();
                              AppDialog().loginFailedDialog(context);
                              print("Login Gagal");
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login),
                            const Text('Login'),
                          ],
                        ),
                      )
                    ],
                  )) /*
              child: FutureBuilder(
                  future: siakad.getCaptcha(),
                  builder:
                      (context, AsyncSnapshot<Map<String, String>> snapshot) {
                    var data = snapshot.data;
                    List<Widget> component = [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school,
                            size: 100.0,
                          ),
                          Text(
                            'SIAKAD',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade400),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: userController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                          hintText: 'Username',
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      StatefulBuilder(builder: (context, setState) {
                        void toggle() {
                          setState(() => obscureText = !obscureText);
                        }

                        return TextFormField(
                          controller: passwordController,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                  onPressed: toggle,
                                  icon: obscureText
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility)),
                              labelText: 'Password'),
                        );
                      }),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Kode Captcha',
                        style: TextStyle(fontSize: 12),
                      ),
                      ColoredBox(
                        color: Color(0xFF455A64),
                        child: Placeholder(
                          fallbackHeight: 65.0,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                          controller: captchaController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Captcha'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Isi captcha';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 10.0,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          AppDialog().buildShowDialog(context);
                          if (data != null) {
                            var login = await siakad.getLogin(
                                user: userController.text,
                                password: passwordController.text,
                                captchaKey: data['captchaKey'] ?? "",
                                captcha: captchaController.text);

                            if (login['statusCode'] == 302 ||
                                login['statusCode'] == 303) {
                              if (context.mounted) context.go('/mahasiswa');
                              Navigator.of(context).pop();
                            } else {
                              print("Login Gagal");
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login),
                            const Text('Login'),
                          ],
                        ),
                      )
                    ];

                    if (data != null && data['src'] != null) {
                      component[7] = Image.network(
                        data['src']!,
                      );
                    }
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: component);
                  })*/
              )),
    );
  }
}
