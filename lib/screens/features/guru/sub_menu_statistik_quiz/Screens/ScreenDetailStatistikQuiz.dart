import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_apps/components/headers_for_sub_menu.dart';

import '../../../../../constants.dart';
import '../../home_guru.dart';
import '../Components/ComponentStatistik.dart';
import 'ScreenMataPelajaran.dart';


class StatistikQuiz extends StatefulWidget {
  static String routeName = "/statistik_quiz";
  static var dataTugas;
  @override
  _StatistikQuiz createState() => _StatistikQuiz();
}

class _StatistikQuiz extends State<StatistikQuiz> {
  @override
  Widget build(BuildContext context) {
    StatistikQuiz.dataTugas =
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
            title: HeadersForMenu('Statistik Quiz'),
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
    Navigator.pushNamed(context, SubMenuMataPelajaranStatistikQuiz.routeName);
    return Future.value(true);
  }
}
