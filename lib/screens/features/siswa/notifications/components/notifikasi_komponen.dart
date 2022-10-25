import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:school_apps/helper/currency_format.dart';
import 'package:school_apps/screens/OnBoarding/OnBoarding.dart';
import 'package:school_apps/screens/features/guru/home/pengumuman.dart';
import 'package:school_apps/screens/features/siswa/home/pengumuman.dart';
import 'package:school_apps/screens/features/siswa/home_siswa.dart';
import 'package:school_apps/screens/features/siswa/keuangan/Screens/DetailTagihanScreens.dart';
import 'package:school_apps/screens/features/siswa/sub_menu_bahan_ajar_siswa/bahan_ajar/bahan_ajar_screen.dart';
import 'package:school_apps/screens/features/siswa/sub_menu_bahan_ajar_siswa/bahan_ajar_screen.dart';
import 'package:school_apps/screens/features/siswa/sub_menu_nilai/mata_pelajaran_screen.dart';
import 'package:school_apps/screens/features/siswa/sub_menu_nilai/nilai_screen.dart';
import 'package:school_apps/screens/features/siswa/sub_menu_quiz_siswa/quiz_screens.dart';
import 'package:school_apps/screens/features/siswa/sub_menu_tugas_siswa/tugas_scareens.dart';
import 'package:school_apps/screens/features/wali_murid/home_walimurid/pengumuman.dart';
import 'package:school_apps/server/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../constants.dart';
import '../../../../../main.dart';
import '../notificationDetail/TagihanPembayaran.dart';

class NotificationComponen extends StatefulWidget {
  @override
  _NotificationComponen createState() => _NotificationComponen();
}

class _NotificationComponen extends State<NotificationComponen> {
  var isLoading = false;
  var responseJson;
  List<Map<String, dynamic>> dataNotif = [];
  List<Map<String, dynamic>> _foundUsers = [];
  var code;
  var nama_akses;
  late bool status = false;

  var data = jsonDecode(dataUserLogin);
  var dataTahunAjaran = jsonDecode(tahunAjaranPref);
  var bulan = '';
  var tgl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      children: [
        isLoading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: mGreyColor,
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (_, __) => (dummyListViewCell()),
                    itemCount: 20,
                  ),
                ),
              )
            : ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                children: [
                  // _search(),
                  SizedBox(
                    height: 15,
                  ),
                  ListView.separated(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: dataNotif == null ? 0 : dataNotif.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 5,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return _dataNotif(
                            '${dataNotif[index]['type']}',
                            '${dataNotif[index]['title']}',
                            '${dataNotif[index]['body']}',
                            '${dataNotif[index]['tgl']}',
                            dataNotif[index]);
                      }),
                  SizedBox(height: 15)
                ],
              )
      ],
    );
  }

  Widget dummyListViewCell() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 48.0,
            height: 48.0,
            color: Colors.white,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 8.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Container(
                  width: double.infinity,
                  height: 8.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Container(
                  width: 40.0,
                  height: 8.0,
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _dataNotif(type, title, body, tgl, data) {
    return GestureDetector(
      onTap: () {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO_REVERSED,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: true,
          title: '$title',
          desc: "$body",
          btnOkOnPress: () async {
            if (type == 'Pengumuman') {
                Navigator.pushNamed(context, DetailPengumumanSiswa.routeName,
                    arguments: data);
            }
            if (type == 'Tugas') {
              Navigator.pushNamed(context, SubMenuTugasSiswa.routeName,
                  arguments: data);
            }
            if (type == 'Tagihan Pembayaran') {
              Navigator.pushNamed(context, DetailTagihanScreens.routeName,
                  arguments: data);
            }
            if (type == 'Nilai') {
              Navigator.pushNamed(context, MataPelajaranLiatNilai.routeName,
                  arguments: data);
            }
            if (type == 'Bahan Ajar') {
              Navigator.pushNamed(context, SubMenuBahanajarSiswa.routeName,
                  arguments: data);
            }
            if (type == 'Quiz') {
              Navigator.pushNamed(context, SubMenuQuizSiswa.routeName,
                  arguments: data);
            }
          },
          btnOkIcon: Icons.navigate_next_rounded,
          btnOkText: 'Detail',
          btnOkColor: kColorTealToSlow,
          btnCancelOnPress: () async {},
          btnCancelIcon: Icons.cancel,
          btnCancelColor: Colors.redAccent,
        ).show();
      },
      child: Container(
          margin: EdgeInsets.only(left: 16, right: 16),
          padding: EdgeInsets.all(10),
          height: 150,
          decoration: BoxDecoration(
              color: mFillColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: mBorderColor, width: 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 180,
                child: Text(
                  type.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: (TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 180,
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width - 60,
                child: Text(
                  body,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 160,
                child: Text(
                  tgl,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              )
            ],
          )),
    );
  }

  Future<String> getData() async {
    setState(() {
      isLoading = true;
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'x-access-token': data['access_token'],
      'username': data['username']
    };

    try {
      final response = await http.get("${getNotification}${data['username']}",
          headers: headers);
      responseJson = json.decode(response.body);

      setState(() {
        isLoading = false;
        status = responseJson['status'];
        code = responseJson['code'];
        if (status == true && code == 200) {
          dataNotif = List<Map<String, dynamic>>.from(
              json.decode(response.body)['result']);
          print(nama_akses);
          print(dataNotif);
        } else if (status == false && code == 403) {
          dataNotif = [];
        } else if (status == false && code == 401) {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Peringatan',
                  desc: "Sesi anda telah habis, mohon login kembali",
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.cancel,
                  onDissmissCallback: (type) async {
                    //SignInScreen
                    Navigator.pushNamedAndRemoveUntil(
                        context, Onboarding.routerName, (r) => false);
                    final pref = await SharedPreferences.getInstance();
                    await pref.clear();
                  },
                  btnOkColor: kColorRedSlow)
              .show();
        } else {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Peringatan',
                  desc: "Terjadi kesalahan pada server",
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.cancel,
                  onDissmissCallback: (type) async {
                    //SignInScreen
                  },
                  btnOkColor: kColorRedSlow)
              .show();
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          status = false;
          isLoading = false;
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Peringatan',
                  desc: "Tidak dapat terhububg ke server",
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.cancel,
                  onDissmissCallback: (type) async {
                    //SignInScreen
                    Navigator.pushNamedAndRemoveUntil(
                        context, HomeSiswa.routeName, (r) => false);
                  },
                  btnOkColor: kColorRedSlow)
              .show();
        });
      }
    }

    return 'success';
  }
}
