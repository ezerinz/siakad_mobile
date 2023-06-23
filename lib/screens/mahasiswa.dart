import 'package:flutter/material.dart';
import 'package:siakad_unsulbar/models/mahasiswa_models.dart';
import 'package:siakad_unsulbar/services/api.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:siakad_unsulbar/ui/app_dialog.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class Mahasiswa extends StatefulWidget {
  final MahasiswaModels object;
  const Mahasiswa({super.key, required this.object});

  @override
  State<Mahasiswa> createState() => _MahasiswaState();
}

class _MahasiswaState extends State<Mahasiswa> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;
  late String name = widget.object.name;
  late List<dynamic> alertList = widget.object.alertList;
  late final List<Widget> _pages = <Widget>[
    MyBeranda(name: name, alert: alertList),
    Center(child: Text('Jadwal Here')),
    MyProfil(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Beranda',
              selectedIcon: Icon(Icons.home),
            ),
            NavigationDestination(
                icon: Icon(Icons.event_note_outlined),
                label: 'Jadwal',
                selectedIcon: Icon(Icons.event_note)),
            NavigationDestination(
                icon: Icon(Icons.person_outline),
                label: 'Profil',
                selectedIcon: Icon(Icons.person)),
          ],
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        ));
  }
}

class MyBeranda extends StatelessWidget {
  const MyBeranda({super.key, required this.name, required this.alert});

  final String name;
  final List<dynamic> alert;
  @override
  Widget build(BuildContext context) {
    var data = alert;
    Widget box;
    Map<String, Widget> fontawesome = {
      'fa-quote-left': FaIcon(
        FontAwesomeIcons.quoteLeft,
        size: 13.4,
        color: Colors.white,
      ),
      'fa-quote-right': FaIcon(
        FontAwesomeIcons.quoteRight,
        size: 13.4,
        color: Colors.white,
      ),
      'fa-exclamation-triangle': FaIcon(FontAwesomeIcons.triangleExclamation,
          size: 13.4, color: Colors.white),
      'fa-credit-card':
          FaIcon(FontAwesomeIcons.creditCard, size: 13.4, color: Colors.white),
      'fa-user': FaIcon(FontAwesomeIcons.user, size: 13.4, color: Colors.white),
      'fa-money-bill':
          FaIcon(FontAwesomeIcons.moneyBill, size: 13.4, color: Colors.white),
    };
    List<Widget> children2_ = [];
    for (var i = 0; i < data.length; i++) {
      List<Widget> children3_ = [];
      Widget b;
      var items = data[i];
      for (var j = 0; j < items.length; j++) {
        var column = data[i][j];
        List<Widget> children_ = [];
        for (var k = 0; k < column.length; k++) {
          var row = data[i][j][k];
          Widget a;
          if (row.toString().contains('fa')) {
            if (fontawesome.containsKey(row.toString())) {
              a = fontawesome[row.toString()]!;
            } else {
              a = Text('$row');
            }
            children_.add(a);
          } else if (row.toString().contains('href')) {
            if (!row.toString().contains('password_change')) {
              var text = row.toString().after('@@').trimAll;
              RegExp exp = RegExp('(?<=href=").*?(?=")');
              var href = exp.firstMatch(row.toString())!;
              var url = Uri.parse('https://${href[0]!}');

              a = TextButton(
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    minimumSize: Size.zero,
                    padding: EdgeInsets.only(top: 2.0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    print(url);
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                  child: Text(
                    '$text',
                    style: TextStyle(color: Colors.white),
                  ));
            } else {
              a = Text('');
            }
            children_.add(a);
          } else {
            row = row.toString().split(' ');
            List<Widget> words = [];
            for (final word in row) {
              a = Text('$word ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600));
              words.add(a);
            }
            children_ += words;
          }
        }
        b = Wrap(
          children: children_,
        );
        children3_.add(b);
      }
      box = DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.deepPurple.shade400,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children3_,
          ),
        ),
      );
      children2_.add(box);
      children2_.add(SizedBox(
        height: 10,
      ));
    }

    SiakadAPI siakad = SiakadAPI();
    return SafeArea(
        child: Stack(children: [
      Column(
        children: [
          Container(
            height: 175,
            color: Colors.deepPurple.shade400,
          ),
        ],
      ),
      Positioned(
          child: Container(
        padding: EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Halo,',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w400, fontSize: 25),
          ),
          Text(name,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30))
          /*FutureBuilder(
              future: siakad.getName(),
              builder: (context, snapshot) {
                var data = snapshot.data;

                if (data != null) {
                  return Text(
                    '$data!',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  );
                } else {
                  return AppDialog().buildShowDialog(context);
                }
              })*/
          ,
          Divider(),
          SizedBox(
            height: 9,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, spreadRadius: 4.0, blurRadius: 2.0)
                ]),
            child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          FloatingActionButton(
                            onPressed: () {},
                            child: Icon(Icons.class_),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            'Kelas',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.deepPurple.shade400),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          FloatingActionButton(
                            onPressed: () {},
                            child: Icon(Icons.playlist_add),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            'KRS',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.deepPurple.shade400),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          FloatingActionButton(
                            onPressed: () {},
                            child: Icon(Icons.content_paste),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            'Hasil Studi',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.deepPurple.shade400),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          FloatingActionButton(
                            onPressed: () {},
                            child: Icon(Icons.summarize),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            'Transkrip',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.deepPurple.shade400),
                          )
                        ],
                      ),
                    ])),
          ),
          SizedBox(
            height: 14,
          ),
          /*
          FutureBuilder(
              future: siakad.getAlert(),
              builder: (context, snapshot) {
                var data = snapshot.data;
                if (data != null) {
                  Widget box;
                  Map<String, Widget> fontawesome = {
                    'fa-quote-left': FaIcon(
                      FontAwesomeIcons.quoteLeft,
                      size: 13.4,
                      color: Colors.white,
                    ),
                    'fa-quote-right': FaIcon(
                      FontAwesomeIcons.quoteRight,
                      size: 13.4,
                      color: Colors.white,
                    ),
                    'fa-exclamation-triangle': FaIcon(
                        FontAwesomeIcons.triangleExclamation,
                        size: 13.4,
                        color: Colors.white),
                    'fa-credit-card': FaIcon(FontAwesomeIcons.creditCard,
                        size: 13.4, color: Colors.white),
                    'fa-user': FaIcon(FontAwesomeIcons.user,
                        size: 13.4, color: Colors.white),
                    'fa-money-bill': FaIcon(FontAwesomeIcons.moneyBill,
                        size: 13.4, color: Colors.white),
                  };
                  List<Widget> children2_ = [];
                  for (var i = 0; i < data.length; i++) {
                    List<Widget> children3_ = [];
                    Widget b;
                    var items = data[i];
                    for (var j = 0; j < items.length; j++) {
                      var column = data[i][j];
                      List<Widget> children_ = [];
                      for (var k = 0; k < column.length; k++) {
                        var row = data[i][j][k];
                        Widget a;
                        if (row.toString().contains('fa')) {
                          if (fontawesome.containsKey(row.toString())) {
                            a = fontawesome[row.toString()]!;
                          } else {
                            a = Text('$row');
                          }
                          children_.add(a);
                        } else if (row.toString().contains('href')) {
                          if (!row.toString().contains('password_change')) {
                            var text = row.toString().after('@@').trimAll;
                            RegExp exp = RegExp('(?<=href=").*?(?=")');
                            var href = exp.firstMatch(row.toString())!;
                            var url = Uri.parse('https://${href[0]!}');

                            a = TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.only(top: 2.0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () async {
                                  print(url);
                                  if (!await launchUrl(url)) {
                                    throw Exception('Could not launch $url');
                                  }
                                },
                                child: Text(
                                  '$text',
                                  style: TextStyle(color: Colors.white),
                                ));
                          } else {
                            a = Text('');
                          }
                          children_.add(a);
                        } else {
                          row = row.toString().split(' ');
                          List<Widget> words = [];
                          for (final word in row) {
                            a = Text('$word ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600));
                            words.add(a);
                          }
                          children_ += words;
                        }
                      }
                      b = Wrap(
                        children: children_,
                      );
                      children3_.add(b);
                    }
                    box = DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.deepPurple.shade400,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: children3_,
                        ),
                      ),
                    );
                    children2_.add(box);
                    children2_.add(SizedBox(
                      height: 10,
                    ));
                  }
                  return Expanded(
                      child: ListView(
                    children: children2_,
                  ));
                } else {
                  return Text('');
                }
              })*/
          Expanded(
              child: ListView(
            children: children2_,
          ))
        ]),
      ))
    ]));
  }
}

class MyProfil extends StatelessWidget {
  const MyProfil({super.key});

  @override
  Widget build(BuildContext context) {
    SiakadAPI siakad = SiakadAPI();
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await siakad.deleteJar();
          if (context.mounted) context.go('/');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout),
            const Text('Logout'),
          ],
        ),
      ),
    );
  }
}
