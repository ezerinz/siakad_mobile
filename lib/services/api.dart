import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:html/dom.dart';
import 'package:string_extensions/string_extensions.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SiakadAPI {
  late final dio = Dio()
    ..options.baseUrl = 'http://siakad.unsulbar.ac.id'
    ..httpClientAdapter = Http2Adapter(
      ConnectionManager(
        idleTimeout: Duration(seconds: 10),
        onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
      ),
    );

  Future<void> prepareJar() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final jar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(appDocPath + "/.cookies/"),
    );
    dio.interceptors.add(CookieManager(jar));
  }

  Future<void> deleteJar() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final jar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(appDocPath + "/.cookies/"),
    );
    jar.deleteAll();
    dio.interceptors.add(CookieManager(jar));
  }

  Future<Map<String, String>> getCaptcha() async {
    await prepareJar();
    final response = await dio.get('https://siakad.unsulbar.ac.id/login');
    var html = Document.html(response.data);
    final captchaSrc = html.querySelector('#Imageid')?.attributes['src'];
    final captchaKey =
        html.querySelector('input[name="_chaptchaKey"]')?.attributes['value'];

    Map<String, String> result = {
      "src": captchaSrc.toString(),
      "key": captchaKey.toString(),
    };
    return result;
  }

  Future<Map<String, dynamic>> getLogin(
      {String user = "",
      String password = "",
      String captchaKey = "",
      String captcha = ""}) async {
    await prepareJar();
    var sendData = {
      'from': 'mahasiswa',
      'user': user,
      'pwd': password,
      '_chaptchaKey': captchaKey,
      'captcha': captcha
    };
    var dat = FormData.fromMap(sendData);

    final response = await dio.post('https://siakad.unsulbar.ac.id/login/act',
        data: dat,
        options: Options(
            followRedirects: false,
            validateStatus: (int? status) {
              if (status != null) {
                return status < 400;
              }
              return false;
            }));

    Map<String, dynamic> result = {'statusCode': response.statusCode};

    return result;
  }

  Future<String> getName() async {
    await prepareJar();
    final response =
        await dio.get('https://siakad.unsulbar.ac.id/mahasiswa/data',
            options: Options(
                followRedirects: false,
                validateStatus: (int? status) {
                  if (status != null) {
                    return status < 400;
                  }
                  return false;
                }));

    var html = Document.html(response.data);
    var getName = html
        .querySelector('input[name="nm_pd"]')
        ?.attributes['value']
        .toString();
    List<String> names = [];
    if (getName != null) {
      names = getName.split(' ');
    }

    String result = names.isNotEmpty && names.length > 1
        ? "${names[0]} ${names[1]}".toTitleCase!
        : names[0].toTitleCase!;

    return result;
  }

  Future<List<dynamic>> getAlert() async {
    await prepareJar();
    final response = await dio.get('https://siakad.unsulbar.ac.id/mahasiswa');
    var html = Document.html(response.data);
    var alert = html.querySelectorAll('[role="alert"]');
    List<dynamic> listAlert = [];
    var count = 0;
    for (final i in alert) {
      var inner = i.innerHtml.toString();
      inner = inner.replaceAll('<p>', '');
      inner = inner.replaceAll('</p>', '');
      inner = inner.replaceAll('<br>', "\n");
      inner = inner.trimAll!;

      listAlert.insert(count, inner.split('\n'));
      count++;
    }

    for (var i = 0; i < listAlert.length; i++) {
      var hasil = [];
      for (var j = 0; j < listAlert[i].length; j++) {
        var halo = listAlert[i][j].replaceAll('<i class="fas ', '#');
        halo = halo.replaceAll('<i class="fa ', '#');
        halo = halo.replaceAll('"></i>', '#');
        halo = halo.replaceAll('<a ', '#');
        halo = halo.replaceAll('target="_blank_">', '@@');
        //halo = halo.replaceAll('</a>', '');
        halo = halo.toString().stripHtml;

        halo = halo.toString().trimAll;
        List<dynamic> res = halo.toString().split('#');
        // remove falsy values from the list
        res.removeWhere((item) => ["", null, false, 0, " "].contains(item));
        hasil.add(res);
      }
      listAlert[i] = hasil;
    }
    return listAlert;
  }
}

void main() async {
  SiakadAPI hello = SiakadAPI();
  await hello.getAlert();
}
