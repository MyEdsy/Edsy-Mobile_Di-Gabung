import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_apps/components/headers_for_sub_menu.dart';

import '../../../../../constants.dart';
import '../../home_guru.dart';
import '../component/ComponentMataPelajaran.dart';


class SubMenuMataPelajaranStatistikTugas extends StatefulWidget {
  static String routeName = "/sub_menu_mata_pelajaran_statistik_tugas";
  @override
  _SubMenuMataPelajaranStatistikTugas createState() => _SubMenuMataPelajaranStatistikTugas();
}

class _SubMenuMataPelajaranStatistikTugas extends State<SubMenuMataPelajaranStatistikTugas> {
  @override
  Widget build(BuildContext context) {
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
          body: ComponentMatapelajaranStatistikTugas(),
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
