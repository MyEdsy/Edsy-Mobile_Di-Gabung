import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:school_apps/components/bottom_navigation_siswa.dart';
import 'package:school_apps/screens/features/siswa/home/siswa_screens.dart';
import 'package:school_apps/screens/features/siswa/profile/profile_screen.dart';
import 'package:school_apps/screens/login/login_screens.dart';
import 'package:school_apps/server/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../../main.dart';
import 'jadwal_pelajaran_siswa/jadwal_pelajaran_guru_screen.dart';
import 'keuangan/Screens/MenuKeuanganScreens.dart';
import 'menu_pembelajaran_siswa/menu_pembelajaran_screens.dart';
import 'notifications/NotificationScreens.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeSiswa extends StatefulWidget {
  static String routeName = "/home_menu_siswa";

  @override
  _HomeSiswa createState() => _HomeSiswa();
}

class _HomeSiswa extends State<HomeSiswa> {
  var isLoading = false, showNavi = false;
  var responseJson, dataTahunAjaran;
  var status, code;

  var data = jsonDecode(dataUserLogin);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _selectedIndex;
  var lastIndex;
  var args;
  var appsV;


  getCurrentPage(int index) {
    if (index == 0) {
      return SiswaScreen();
    } else if (index == 1) {
      return MenuPembelajaranSiswa();
    } else if (index == 2) {
      // return JadwalPelajaranSiswa();
      return MenuKeuanganScreens();
    } else if (index == 3) {
      return ProfileSiswaScreen();
    } else {}
  }

  _getDataUsers() async {
    //end firebase setting
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    dataUserLogin = sharedPreferences.getString("dataUser");
    tahunAjaranPref = sharedPreferences.getString("tahunAjaran");
    dataBaseUrl = sharedPreferences.getString("dataBaseUrl");
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)?.settings.arguments;
        if (args != null) {
          // int to = args['to'];
          _selectedIndex = args['to'];
        }
      });
    });
    setState(() {
      this._getDataUsers();
      // getData();
      _selectedIndex = 0;
    });
    getAppVersion();

    //firebase config
    // when app is closed and it will be called only once
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print("fireabse closed app msg");

      if (message != null) {
        print(" firebase msg received closed add " + message.data.toString());
        // Navigator.push(context, MaterialPageRoute(builder: (context){ return product(prodid: message.data["prodid"]);}));
        // Navigator.pushNamed(context, NotificationScreen.routeName);
        /*  Navigator.pushNamed(context, '/message',
        arguments: MessageArguments(message, true));
        */

      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Log.d("Printing on Message Notification click");
      message.data.keys.forEach((element) {
        print("Printing on Message Notification click keys ${element}");
      });
      if (message != null) {
        if (message.data.isNotEmpty) {
          String course_id = message.data['course_id'] as String;
          String type = message.data['type'] as String;
        }
        Navigator.pushNamed(context, NotificationScreen.routeName);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

  }

  void showMessage({required RemoteMessage message}) async {
    if (message.data['route'] == "mypage") {
      var myparams = message.data['payload'];
      print(myparams);
      // Navigator.of(context).push(MaterialPageRoute(
      //     fullscreenDialog: true,
      //     builder: (_) {
      //       print("Blahhh ");
      //     }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          // Setting up AppBar
          key: _scaffoldKey,
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : Stack(
                  children: <Widget>[
                    getCurrentPage(_selectedIndex),
                  ],
                ),
          bottomNavigationBar:
              BottomNavigationSiswa(_selectedIndex, onTabChange: (index) {
            _selectedIndex = index;
            setState(() {});
            if (_selectedIndex == 3 && _selectedIndex == lastIndex) {}
            lastIndex = index;
          }),
        ),
        onWillPop: _onBackPressed);
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    exit(0);
  }

  //http://dev.edsy.ubl.ac.id:5070/app-version

  Future<String> getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

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
      final response = await http.get("${tahunAjaran}", headers: headers);
      responseJson = json.decode(response.body);
      // Future.delayed(Duration(seconds: 2)).then((value) {
      //   utilsApps.hideDialog(context);
      // });
      setState(() {
        isLoading = false;
        status = responseJson['status'];
        code = responseJson['code'];
        if (status == true && code == 200) {
          dataTahunAjaran = responseJson['result'];
          sharedPreferences.setString(
              'tahunAjaran', jsonEncode(dataTahunAjaran));
          sharedPreferences.commit();
          // Navigator.pushNamed(context, HomeGuru.routeName);
        } else if (status == false && code == 403) {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Peringatan',
                  desc: responseJson['message'],
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.check,
                  onDissmissCallback: (type) {
                    //SignInScreen
                    Navigator.pushNamedAndRemoveUntil(
                        context, HomeSiswa.routeName, (r) => false);
                    // Navigator.pushNamed(
                    //     context, SignInScreen.routeName);
                  },
                  btnOkColor: kColorYellow)
              .show();
        } else {
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
                        context, SignInScreen.routeName, (r) => false);
                    final pref = await SharedPreferences.getInstance();
                    await pref.clear();
                  },
                  btnOkColor: kColorRedSlow)
              .show();
        }
      });
    } catch (e) {
      setState(() {
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

    return 'success';
  }

  Future<String> getAppVersion() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
    };
    try {
      final response = await http.get("http://dev.edsy.ubl.ac.id:5070/app-version", headers: headers);
      responseJson = json.decode(response.body);
      // Future.delayed(Duration(seconds: 2)).then((value) {
      //   utilsApps.hideDialog(context);
      // });
      setState(() {
        isLoading = false;
        status = responseJson['status'];
        code = responseJson['code'];
        if (status == true && code == 200) {
          appsV = responseJson['result']['appVersion'];
          if(appsV > 20220916) {
            AwesomeDialog(
                context: context,
                dialogType: DialogType.WARNING,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                btnOkText: "Update Sekarang",
                title: 'Peringatan',
                desc: "Ada pembaruan aplikasi. Silahkan update aplikasi sekarang untuk mendapatkan layanan yang maksimal",
                btnOkOnPress: () {},
                btnOkIcon: Icons.update,
                onDissmissCallback: (type) {
                  String os = Platform.operatingSystem;
                  if(os == 'ios') {
                    _launchInBrowser('https://apps.apple.com/id/app/edsy/id1613510009?l=id');
                  }else if (os == 'android') {
                    _launchInBrowser('https://play.google.com/store/apps/details?id=com.edsy.school_apps&hl=id');
                  }
                },
                btnOkColor: kColorYellow)
                .show();
          }
        } else if (status == false && code == 403) {

        } else {

        }
      });
    } catch (e) {
    }
    return 'success';
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
