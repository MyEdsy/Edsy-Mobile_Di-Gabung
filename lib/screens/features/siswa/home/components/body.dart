import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:school_apps/components/slider_all.dart';
import 'package:school_apps/screens/features/siswa/home/components/pengumuman.dart';

import '../../../../../constants.dart';
import '../../../../../main.dart';
import 'component_kelas_hari_ini.dart';
import 'component_menu_siswa.dart';
import 'component_tugas.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  var data = jsonDecode(dataUserLogin);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          // Promos Section
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, bottom: 10),
            child: Text(
              'Hi, ${data['nama']} 👋\nSelamat datang di EDSY!',
              style: mTitleStyle,
            ),
          ),
          SliderAll(),
          SizedBox(
            height: 12,
          ),
          // Service Section
          MenuSiswa(),
          PengumumanSiswa(),
          // Popular Destination Section
          Materi(),
          SizedBox(
            height: 12,
          ),
          KelasHariIni(),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
