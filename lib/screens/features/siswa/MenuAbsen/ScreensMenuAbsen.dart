import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school_apps/components/slider_all.dart';

import '../../../../components/headers_for_sub_menu.dart';
import '../../../../constants.dart';
import '../../../../main.dart';
import '../../../../size_config.dart';
import 'ComponentsMenuAbsen.dart';

class ScreensMenuAbsen extends StatefulWidget {
  static String routeName = "/menu_absen_siswa";
  @override
  _ScreensMenuAbsen createState() => _ScreensMenuAbsen();
}

class _ScreensMenuAbsen extends State<ScreensMenuAbsen> {
  var data = jsonDecode(dataUserLogin);
  @override
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      // Setting up AppBar
        appBar: AppBar(
          backgroundColor: mBackgroundColor,
          // automaticallyImplyLeading: false,
          title: HeadersForMenu('Presensi Kelas'),
          elevation: 0,
        ),
        backgroundColor: mBackgroundColor,
        body: Container(
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              // Promos Section
              SizedBox(
                height: 5,
              ),
              // Service Section
              ComponentMenuAbsenSiswa(),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ));
  }
}
