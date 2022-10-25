import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_apps/components/headers_for_sub_menu.dart';
import '../../../../../constants.dart';
import 'component/body.dart';


class PresensiPerhariScreens extends StatelessWidget {
  static String routeName = "/presensi_siswa_perhari";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setting up AppBar
        appBar: AppBar(
          backgroundColor: mBackgroundColor,
          // automaticallyImplyLeading: false,
          title: HeadersForMenu('Presensi Perhari'),
          elevation: 0,
        ),
        backgroundColor: mBackgroundColor,
        body: Body()
    );
  }
}
