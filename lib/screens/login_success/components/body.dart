import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:school_apps/components/default_button.dart';
import 'package:school_apps/screens/OnBoarding/OnBoarding.dart';
import 'package:school_apps/screens/features/guru/home/guru_screens.dart';
import 'package:school_apps/screens/features/guru/home_guru.dart';
import 'package:school_apps/screens/features/siswa/home/siswa_screens.dart';
import 'package:school_apps/screens/features/siswa/home_siswa.dart';
import 'package:school_apps/screens/features/wali_murid/home_walimurid.dart';
import 'package:school_apps/server/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../../main.dart';
import '../../../size_config.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  // var responseJson, dataTahunAjaran;

  _getDataUsers() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    dataUserLogin = sharedPreferences.getString("dataUser");
    tahunAjaranPref = sharedPreferences.getString("tahunAjaran");
  }

  var isLoading = false;
  var responseJson;
  var code;
  late bool status;

  @override
  void initState() {
    super.initState();
    setState(() {
      this._getDataUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataUser = ModalRoute.of(context)!.settings.arguments as Map;
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Image.asset(
          "assets/images/success_.png",
          // height: SizeConfig.screenHeight * 0.4, //40%
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Text(
          "Berhasil Login",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(30),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Spacer(),
        SizedBox(
          width: SizeConfig.screenWidth * 0.6,
          child: DefaultButton(
            text: "Lanjutkan",
            press: () async{
              if (dataUser['nama_akses'] == 'Guru') {
                Navigator.pushNamed(context, HomeGuru.routeName);
                String? token = await FirebaseMessaging.instance.getToken();
                updateTokenFireBase(dataUser['username'], token);
              } else if (dataUser['nama_akses'] == 'Orang Tua') {
                Navigator.pushNamed(context, HomeWaliMurid.routeName);
                String? token = await FirebaseMessaging.instance.getToken();
                updateTokenFireBase(dataUser['username'], token);
              } else if(dataUser['nama_akses'] == 'Siswa'){
                Navigator.pushNamed(context, HomeSiswa.routeName);
                String? token = await FirebaseMessaging.instance.getToken();
                updateTokenFireBase(dataUser['username'], token);
              }else {
                AwesomeDialog(
                        context: context,
                        dialogType: DialogType.WARNING,
                        animType: AnimType.RIGHSLIDE,
                        headerAnimationLoop: true,
                        title: 'Peringatan',
                        desc: 'Gagal authentikasi',
                        btnOkOnPress: () {
                          Navigator.pushNamed(context, Onboarding.routerName);
                        },
                        btnOkIcon: Icons.check,
                        onDissmissCallback: (type) {},
                        btnOkColor: kColorYellow)
                    .show();
              }
            },
          ),
        ),
        Spacer(),
      ],
    );
  }

  Future<String> updateTokenFireBase(username, token) async {
    setState(() {
      isLoading = true;
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
    };
    try {
      final response = await http.get("${updateToken}$username?token=$token",
          headers: headers);
      responseJson = json.decode(response.body);

      setState(() {
        isLoading = false;
        status = responseJson['status'];
        code = responseJson['code'];
        if (status == true && code == 200) {
          print("Berhasil update token");
        } else if (status == false && code == 403) {
        } else {

        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          status = false;
          isLoading = false;

        });
      }
    }

    return 'success';
  }
}
