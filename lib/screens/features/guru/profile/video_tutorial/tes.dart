import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_apps/constants.dart';
import 'package:http/http.dart' as http;
import 'package:school_apps/main.dart';
import 'package:school_apps/screens/OnBoarding/OnBoarding.dart';
import 'package:school_apps/screens/features/guru/home_guru.dart';
import 'package:school_apps/screens/features/guru/profile/video_tutorial/nonton_video.dart';
import 'package:school_apps/screens/features/guru/profile/video_tutorial/video_app_theme.dart';
import 'package:school_apps/server/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListDataTes extends StatefulWidget {
  ListDataTes({
    Key? key,
    // this.animationController,
    // this.hotelData,
    // this.animation,
    // this.callback
  }) : super(key: key);

  // final VoidCallback? callback;
  // final HotelListData? hotelData;
  // final AnimationController? animationController;
  // final Animation<double>? animation;

  @override
  _ListDataTesState createState() => _ListDataTesState();
}

class _ListDataTesState extends State<ListDataTes> {
  var isLoading = false;
  var responseJson;
  var status, code;

  var thumbnail = "", title = "", subtitle = "", link = "";

  var dataa = jsonDecode(dataUserLogin);
  var dataTahunAjaran = jsonDecode(tahunAjaranPref);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();
  }

  // List<HotelListData> hotelList = <HotelListData>[
  //   HotelListData(
  //     thumbnail: 'assets/tutorial/1.png',
  //     title: 'A.1 Cara Melakukan Presensi Di Akun Guru',
  //     subtitle: 'Bab 1 - Bag 1',
  //     link:
  //         'https://www.youtube.com/watch?v=12uq606VOKE&list=PLw-TFqGsAV_IvtfOgWMfoW63anN_tZFmn',
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        
      ],
    );
  }

  // Future<String> getData() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json;charset=UTF-8',
  //     'Charset': 'utf-8',
  //     'x-access-token': dataa['access_token'],
  //     'username': dataa['username']
  //   };
  //   print("${videoTutorialGuru}");

  //   try {
  //     final response = await http.get("${videoTutorialGuru}", headers: headers);
  //     responseJson = json.decode(response.body);
  //     // Future.delayed(Duration(seconds: 2)).then((value) {
  //     //   utilsApps.hideDialog(context);
  //     // });
  //     setState(() {
  //       isLoading = false;
  //       status = responseJson['status'];
  //       code = responseJson['code'];
  //       if (status == true && code == 200) {
  //         thumbnail = responseJson['result']['thumbnail'];
  //         title = responseJson['result']['title'];
  //         subtitle = responseJson['result']['subtitle'];
  //         link = responseJson['result']['link'];
  //       } else if (status == false && code == 403) {
  //         AwesomeDialog(
  //                 context: context,
  //                 dialogType: DialogType.WARNING,
  //                 animType: AnimType.RIGHSLIDE,
  //                 headerAnimationLoop: true,
  //                 title: 'Peringatan',
  //                 desc: responseJson['message'],
  //                 btnOkOnPress: () {},
  //                 btnOkIcon: Icons.check,
  //                 onDissmissCallback: (type) {
  //                   //SignInScreen
  //                   // Navigator.pushNamedAndRemoveUntil(
  //                   //     context, Home.routeName, (r) => false);
  //                   // Navigator.pushNamed(
  //                   //     context, SignInScreen.routeName);
  //                 },
  //                 btnOkColor: kColorYellow)
  //             .show();
  //       } else {
  //         AwesomeDialog(
  //                 context: context,
  //                 dialogType: DialogType.ERROR,
  //                 animType: AnimType.RIGHSLIDE,
  //                 headerAnimationLoop: true,
  //                 title: 'Peringatan',
  //                 desc: "Sesi anda telah habis, mohon login kembali",
  //                 btnOkOnPress: () {},
  //                 btnOkIcon: Icons.cancel,
  //                 onDissmissCallback: (type) async {
  //                   //SignInScreen
  //                   Navigator.pushNamedAndRemoveUntil(
  //                       context, Onboarding.routerName, (r) => false);
  //                   final pref = await SharedPreferences.getInstance();
  //                   await pref.clear();
  //                 },
  //                 btnOkColor: kColorRedSlow)
  //             .show();
  //       }
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //       AwesomeDialog(
  //               context: context,
  //               dialogType: DialogType.ERROR,
  //               animType: AnimType.RIGHSLIDE,
  //               headerAnimationLoop: true,
  //               title: 'Peringatan',
  //               desc: "Tidak dapat terhubung ke server",
  //               btnOkOnPress: () {},
  //               btnOkIcon: Icons.cancel,
  //               onDissmissCallback: (type) async {
  //                 //SignInScreen
  //                 Navigator.pushNamedAndRemoveUntil(
  //                     context, HomeGuru.routeName, (r) => false);
  //               },
  //               btnOkColor: kColorRedSlow)
  //           .show();
  //     });
  //   }

  //   return 'success';
  // }
}
