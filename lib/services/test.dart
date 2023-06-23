import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:string_extensions/string_extensions.dart';

void main() async {
  late final dio = Dio()
    ..options.baseUrl = 'http://siakad.unsulbar.ac.id'
    ..httpClientAdapter = Http2Adapter(
      ConnectionManager(
        idleTimeout: Duration(seconds: 10),
        onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
      ),
    );
  final response = await dio.get('https://siakad.unsulbar.ac.id/mahasiswa',
      options: Options(
          headers: {'cookie': 'ci_session=hrnid7btsdettlc0ofohh4ejf4rvm1ng'}));
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
  print(listAlert[1]);
}
