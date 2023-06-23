import 'package:html/dom.dart';
import 'package:string_extensions/string_extensions.dart';

void main() {
  var string = '<a href="bit.ly/briva-siakad"> Dokumen Panduan Pembayaran</a>';
  string = string.replaceAll('<a', '');
  string = string.replaceAll('</a>', '');
  //string = string.replaceAll('>', '@@');
  RegExp exp = RegExp('(?<=href=").*?(?=")');
  var href = exp.firstMatch(string)!;
  print(href[0]);
  RegExp exp2 = RegExp(r'(?<=href="' + href[0]! + r'").*?(?=\s)');
  string = string.replaceAll(exp2, '@@');
  var text = string.after('@@');
  print(string);
  print(text);

  //print(string);
}
