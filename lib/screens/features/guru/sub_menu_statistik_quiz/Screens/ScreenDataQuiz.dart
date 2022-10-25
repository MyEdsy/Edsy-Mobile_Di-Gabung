import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_apps/components/headers_for_sub_menu.dart';

import '../../../../../constants.dart';
import '../../home_guru.dart';
import '../Components/ComponenQuiz.dart';


class ScreenDataQuiz extends StatefulWidget {
  static String routeName = "/sub_menu_statistik_quiz";
  static var dataMapelPerIndex;
  @override
  _ScreenDataQuiz createState() => _ScreenDataQuiz();
}

class _ScreenDataQuiz extends State<ScreenDataQuiz> {

  @override
  Widget build(BuildContext context) {
    ScreenDataQuiz.dataMapelPerIndex =
    ModalRoute.of(context)!.settings.arguments as Map;

    // print(SubMenuMataStatistikTugas.dataMapelPerIndex);
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
          body: ComponentQuiz(),
        ),
        onWillPop: _onBackPressed);
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomeGuru()),
    // );
    Navigator.pushNamed(context, HomeGuru.routeName, arguments: {'to': 1});
    return Future.value(true);
  }
}
