import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:school_apps/screens/OnBoarding/OnBoarding.dart';
import 'package:school_apps/screens/features/wali_murid/profil/components/profil_menu.dart';
import 'package:school_apps/screens/features/wali_murid/profil/components/profil_pic.dart';
import 'package:school_apps/screens/features/wali_murid/profil/detail_profil_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../constants.dart';
import '../../../../../main.dart';
import 'package:http/http.dart' as http;

import '../../../../../server/api.dart';

class BodyProfil extends StatefulWidget {
  const BodyProfil({Key? key}) : super(key: key);
  @override
  State createState() => _BodyProfil();
}

class _BodyProfil extends State<BodyProfil> {
  // const BodyProfil({Key? key}) : super(key: key);
  var isLoading = false;
  var responseJson, result;
  var code;
  late bool status;

  var data = jsonDecode(dataUserLogin);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const WaliMuridProfilePic(),
          const SizedBox(height: 20),
          WaliMuridProfileMenu(
            text: "My Account",
            icon: "assets/icons/User.svg",
            press: () {
              Navigator.pushNamed(context, WaliMuridDetailProfileSiswaScreen.routeName);
            },
          ),
          WaliMuridProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.WARNING,
                      animType: AnimType.RIGHSLIDE,
                      headerAnimationLoop: true,
                      title: 'Peringatan',
                      desc: "Dalam pengembangan",
                      btnOkOnPress: () {},
                      btnOkIcon: Icons.cancel,
                      btnOkColor: kColorYellow)
                  .show();
            },
          ),
          WaliMuridProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.WARNING,
                      animType: AnimType.RIGHSLIDE,
                      headerAnimationLoop: true,
                      title: 'Peringatan',
                      desc: "Dalam pengembangan",
                      btnOkOnPress: () {},
                      btnOkIcon: Icons.cancel,
                      btnOkColor: kColorYellow)
                  .show();
            },
          ),
          WaliMuridProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.WARNING,
                      animType: AnimType.RIGHSLIDE,
                      headerAnimationLoop: true,
                      title: 'Peringatan',
                      desc: "Dalam pengembangan",
                      btnOkOnPress: () {},
                      btnOkIcon: Icons.cancel,
                      btnOkColor: kColorYellow)
                  .show();
            },
          ),
          WaliMuridProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () async {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.WARNING,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'Peringatan',
                desc: "Yakin ingin keluar",
                btnOkOnPress: () async {
                  logOut();
                  final pref = await SharedPreferences.getInstance();
                  await pref.clear();
                  Navigator.pushNamedAndRemoveUntil(
                      context, Onboarding.routerName, (r) => false);
                },
                btnOkIcon: Icons.check,
                btnOkColor: kColorTealToSlow,
                btnCancelOnPress: () async {},
                btnCancelIcon: Icons.cancel,
                btnCancelColor: kColorRedSlow,
              ).show();
            },
          ),
        ],
      ),
    );
  }

  Future<String> logOut() async {
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
      final response = await http.get(
          "${keluar}",
          headers: headers);
      responseJson = json.decode(response.body);

      setState(() {
        isLoading = false;
        status = responseJson['status'];
        code = responseJson['code'];
        if (status == true && code == 200) {
          result = responseJson['result'];
          print(result);
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
