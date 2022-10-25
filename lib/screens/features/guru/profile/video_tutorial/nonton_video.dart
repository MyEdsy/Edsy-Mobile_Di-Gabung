import 'package:flutter/material.dart';
import 'package:school_apps/components/headers_for_sub_menu.dart';
import 'package:school_apps/constants.dart';
import 'package:school_apps/screens/features/guru/profile/video_tutorial/model/video_list_data.dart';
import 'package:school_apps/screens/features/guru/profile/video_tutorial/video_app_theme.dart';
import 'package:school_apps/screens/features/guru/profile/video_tutorial/video_home_screen.dart';
import 'package:school_apps/screens/features/guru/profile/video_tutorial/video_list_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NontonVideo extends StatefulWidget {
  static String routeName = "/play_video_tutorial";
  static var args;
  // var HotelListData? hotelData;
  // var url = 'https://www.youtube.com/watch?v=d4CF4km1rUQ';
  @override
  _NontonVideoState createState() => _NontonVideoState();
}

class _NontonVideoState extends State<NontonVideo> {
  @override
  Widget build(BuildContext context) {
    NontonVideo.args = ModalRoute.of(context)!.settings.arguments as Map;
    String link = YoutubePlayer.convertUrlToId(NontonVideo.args['link'])!;
    print(NontonVideo.args);
    return WillPopScope(
        child: OrientationBuilder(builder: (context, orientaion) {
          switch (orientaion) {
            case Orientation.portrait:
              return Scaffold(
                  // Setting up AppBar
                  appBar: AppBar(
                    backgroundColor: mBackgroundColor,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.blueGrey,
                      onPressed: () {
                        _onBackPressed();
                      },
                    ),
                    // automaticallyImplyLeading: false,
                    title: HeadersForMenu('Video Tutorial'),
                    elevation: 0,
                  ),
                  backgroundColor: mBackgroundColor,
                  body: ListView(
                    children: [
                      YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: link, //Add videoID. /*Tes Tes Tes
                          flags: YoutubePlayerFlags(
                            hideControls: false,
                            controlsVisibleAtStart: true,
                            autoPlay: true,
                            mute: false,
                          ),
                        ),
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: kPrimaryColor,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 10, right: 10),
                      //   child: Text(
                      //     args['judul_video'],
                      //     overflow: TextOverflow.ellipsis,
                      //     maxLines: 4,
                      //     style: mTitleStyle16,
                      //   ),
                      // ),
                    ],
                  ));

              // TODO: Handle this case.
              break;
            case Orientation.landscape:
              return Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Theme.of(context).appBarTheme.color,
                  body: YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId: link, //Add videoID. /**Tes Tes Tes */
                      flags: YoutubePlayerFlags(
                        hideControls: false,
                        controlsVisibleAtStart: true,
                        autoPlay: false,
                        mute: false,
                      ),
                    ),
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: kPrimaryColor,
                  ));

              // TODO: Handle this case.
              break;
          }
        }),
        onWillPop: _onBackPressed);
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    Navigator.pop(context);
    return Future.value(true);
  }
}
