import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_apps/components/headers_for_sub_menu.dart';
import 'package:school_apps/screens/features/guru/home_guru.dart';
import 'package:school_apps/screens/features/siswa/home_siswa.dart';

import '../../../../../constants.dart';
import '../../../../../main.dart';


class TagihanPembayaranScreens extends StatefulWidget {
  static String routeName = "/tagihan_notifkasi";
  static var dataNotif;
  @override
  _TagihanPembayaranScreens createState() => _TagihanPembayaranScreens();
}

class _TagihanPembayaranScreens extends State<TagihanPembayaranScreens> {
  var data = jsonDecode(dataUserLogin);
  @override
  Widget build(BuildContext context) {
    TagihanPembayaranScreens.dataNotif = ModalRoute.of(context)!.settings.arguments;
    return WillPopScope(
        child: Scaffold(
          // Setting up AppBar
          appBar: AppBar(
            backgroundColor: mBackgroundColor,
            title: HeadersForMenu('Notifikasi'),
            elevation: 0,
          ),
          backgroundColor: mBackgroundColor,
          body: Container(child: Text("Blah ${TagihanPembayaranScreens.dataNotif['no_invoice']}"),),
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
