import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_apps/components/headers_for_sub_menu.dart';
import 'package:school_apps/screens/features/guru/home_guru.dart';
import 'package:school_apps/screens/features/siswa/home_siswa.dart';

import '../../../../constants.dart';
import '../../../../main.dart';
import 'components/notifikasi_komponen.dart';

class NotificationScreen extends StatefulWidget {
  static String routeName = "/notification";
  @override
  _Notification createState() => _Notification();
}

class _Notification extends State<NotificationScreen> {
  var data = jsonDecode(dataUserLogin);
  @override
  Widget build(BuildContext context) {
    print(data);
    return WillPopScope(
        child: Scaffold(
          // Setting up AppBar
          appBar: AppBar(
            backgroundColor: mBackgroundColor,
            title: HeadersForMenu('Notifikasi'),
            elevation: 0,
          ),
          backgroundColor: mBackgroundColor,
          body: NotificationComponen(),
        ),
        onWillPop: _onBackPressed);
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomeSiswa()),
    // );
    if(data['nama_akses'] == 'Siswa') {
      Navigator.pushNamed(context, HomeSiswa.routeName, arguments: {'to': 0});
    }else {
      Navigator.pushNamed(context, HomeGuru.routeName, arguments: {'to': 0});
    }
    return Future.value(true);
  }
}
