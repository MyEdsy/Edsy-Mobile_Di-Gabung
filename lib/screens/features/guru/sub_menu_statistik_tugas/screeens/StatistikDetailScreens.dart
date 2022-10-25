import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_apps/components/headers_for_sub_menu.dart';

import '../../../../../constants.dart';
import '../../home_guru.dart';
import '../component/ComponentMataPelajaran.dart';
import '../component/ComponentStatistik.dart';
import 'ScreenMataPelajaran.dart';


class StatistikTugas extends StatefulWidget {
  static String routeName = "/statistik_tugas";
  static var dataTugas;
  @override
  _StatistikTugas createState() => _StatistikTugas();
}

class _StatistikTugas extends State<StatistikTugas> {
  @override
  Widget build(BuildContext context) {
    StatistikTugas.dataTugas =
    ModalRoute.of(context)!.settings.arguments as Map;

    // print(sub_menu_statistik_quiz.dataTugas['id']);
    return WillPopScope(
        child: Scaffold(
          // Setting up AppBar
          appBar: AppBar(
            backgroundColor: mBackgroundColor,
            // leading: IconButton(
            //   icon: Icon(Icons.arrow_back),
            //   color: Colors.blueGrey,
            //   onPressed: () {
            //     _onBackPressed();
            //   },
            // ),
            // automaticallyImplyLeading: false,
            title: HeadersForMenu('Statistik Tugas'),
            elevation: 0,
          ),
          backgroundColor: mBackgroundColor,
          body: BarChart(),
        ),
        onWillPop: _onBackPressed);
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomeGuru()),
    // );
    Navigator.pushNamed(context, SubMenuMataPelajaranStatistikTugas.routeName);
    return Future.value(true);
  }
}
