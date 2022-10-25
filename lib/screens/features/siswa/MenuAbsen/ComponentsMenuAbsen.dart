import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school_apps/screens/features/siswa/sub_menu_jadwal/jadwal_screen.dart';
import 'package:school_apps/screens/features/siswa/sub_menu_kesiswaan/kesiswaan_screen.dart';
import 'package:school_apps/screens/features/siswa/sub_menu_nilai/mata_pelajaran_screen.dart';
import 'package:school_apps/screens/features/siswa/sub_menu_presensi/mata_pelajaran_screen.dart';

import '../../../../../constants.dart';
import '../PresensiPerhari/PresensiPerhariScreens.dart';

class ComponentMenuAbsenSiswa extends StatefulWidget {
  @override
  _ComponentMenuAbsenSiswa createState() => _ComponentMenuAbsenSiswa();
}

class _ComponentMenuAbsenSiswa extends State<ComponentMenuAbsenSiswa> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, top: 10, bottom: 12),
          child: Text(
            'Presensi',
            style: mTitleStyle,
          ),
        ),
        Container(
          height: 144,
          margin: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, PresensiPerhariScreens.routeName),
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.only(left: 16),
                        height: 64,
                        decoration: BoxDecoration(
                          color: mFillColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: mBorderColor, width: 1),
                        ),
                        child: Row(
                          children: <Widget>[
                            Image.asset('assets/images/management.png'),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Perhari',
                                    style: mServiceTitleStyle,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text('Lihat Presensi Perhari',
                                      style: mServiceSubtitleStyle)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, MataPelajaranLiatAbsen.routeName),
                        child: Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.only(left: 16),
                          height: 64,
                          decoration: BoxDecoration(
                            color: mFillColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: mBorderColor, width: 1),
                          ),
                          child: Row(
                            children: <Widget>[
                              Image.asset('assets/images/absen.png'),
                              Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Permapel',
                                      style: mServiceTitleStyle,
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text('Lihat Presensi \nPermata Pelajaran',
                                        style: mServiceSubtitleStyle)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
