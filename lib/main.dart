import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:school_apps/routes.dart';
import 'package:school_apps/screens/OnBoarding/OnBoarding.dart';
import 'package:school_apps/screens/features/guru/home_guru.dart';
import 'package:school_apps/screens/features/siswa/home_siswa.dart';
import 'package:school_apps/screens/features/wali_murid/home_walimurid.dart';
import 'package:school_apps/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

var dataUserLogin;
var dataBaseUrl;
var tahunAjaranPref;
bool? login = false;
bool? setDataIp = false;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri? deepLink = dynamicLink.link;

      if (deepLink != null) {
        Navigator.pushNamed(context, deepLink.path);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path, arguments: data);
    }
  }

  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //firebase
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getInitialMessage();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  //end firebase setting

  SharedPreferences sharedPreferences;
  sharedPreferences = await SharedPreferences.getInstance();
  login = sharedPreferences.getBool("login");
  String defaultRoutes;

  if (login != null) {
    if (login == false) {
      defaultRoutes = Onboarding.routerName;
    } else {
      dataUserLogin = sharedPreferences.getString("dataUser");
      tahunAjaranPref = sharedPreferences.getString("tahunAjaran");
      print(tahunAjaranPref);
      var data = jsonDecode(dataUserLogin);
      if (data['nama_akses'] == 'Guru') {
        defaultRoutes = HomeGuru.routeName;
      } else if (data['nama_akses'] == 'Orang Tua') {
        defaultRoutes = HomeWaliMurid.routeName;
      } else {
        defaultRoutes = HomeSiswa.routeName;
      }
    }
  } else {
    // defaultRoutes = SignInScreen.routeName;
    defaultRoutes = Onboarding.routerName;
  }

  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp]
  // ).then((_) {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'School Apps',
    theme: theme(),
    initialRoute: defaultRoutes,
    routes: routes,
  ));
  // });
}
