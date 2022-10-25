import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_apps/components/headers_for_sub_menu.dart';
import 'package:school_apps/constants.dart';
import 'package:school_apps/screens/features/guru/home_guru.dart';
import 'package:school_apps/screens/features/guru/profile/video_tutorial/bodyVideoList.dart';

class VideoTutorialGuruScreen extends StatefulWidget {
  static String routeName = "/video_tutorial_guru_screen";
  @override
  _VideoTutorialGuruScreen createState() => _VideoTutorialGuruScreen();
}

class _VideoTutorialGuruScreen extends State<VideoTutorialGuruScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          // Setting up AppBar
          appBar: AppBar(
            backgroundColor: mBackgroundColor,
            // leading: IconButton(
            //   icon: Icon(Icons.arrow_back),
            //   color: Colors.blueGrey,
            //   onPressed: () {
            //     _onBackPressed();
            //   },
            // ),
            // automaticallyImplyLeading: false,
            title: HeadersForMenu('Video Tutorial Guru'),
            elevation: 0,
          ),
          backgroundColor: mBackgroundColor,
          body: VideoTutorialBody(),
        ),
        onWillPop: _onBackPressed);
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomeGuru()),
    // );
    Navigator.pop(context);
    return Future.value(true);
  }
}
