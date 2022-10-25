import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:school_apps/screens/features/guru/sub_menu_bahan_ajar/bahan_ajar/input_video_screen.dart';
import 'package:school_apps/screens/features/guru/sub_menu_bahan_ajar/bahan_ajar/play_video_screen.dart';
import 'package:school_apps/screens/features/guru/sub_menu_bahan_ajar/bahan_ajar/respones/bahanMengajarResponse.dart';
import 'package:school_apps/screens/login/login_screens.dart';
import 'package:school_apps/server/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../../constants.dart';
import '../../../../../../main.dart';
import '../../../../../../size_config.dart';
import '../../../home_guru.dart';
import '../bahan_ajar_screen.dart';

class ComponentBahanAjar extends StatefulWidget {
  @override
  _ComponentBahanAjar createState() => _ComponentBahanAjar();
}

class _ComponentBahanAjar extends State<ComponentBahanAjar> {
  var isLoading = false, isLoadingVideo = false, isLoadingFile = false;
  var responseJson,
      // dataBahanAjar,
      responseJsonVideo,
      dataVideo,
      responseJsonFile,
      dataFile;
  var status, code;

  List<Map<String, dynamic>> _foundUsers = [];
  List<Map<String, dynamic>> dataBahanAjar = [];

  var data = jsonDecode(dataUserLogin);
  var dataTahunAjaran = jsonDecode(tahunAjaranPref);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: mGreyColor,
              child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, __) => (dummyListViewCell()),
                itemCount: 10,
              ),
            ),
          )
        : _foundUsers.isEmpty
            ? ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                children: [
                  _search(),
                  SizedBox(height: 15,),
                  ListView.separated(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount:
                          dataBahanAjar == null ? 0 : dataBahanAjar.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 5,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return _listMataPelajaran(
                          dataBahanAjar[index]['judul'],
                          dataBahanAjar[index]['keterangan'],
                          GestureDetector(
                            // onTap: () => Navigator.pushNamed(
                            //     context, InputKategoriNilai.routeName,
                            //     arguments: dataMapel[index]),
                            onTap: () {
                              setState(() {
                                getDatavideo(dataBahanAjar[index]['id']);
                              });
                            },
                            child: const Chip(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              avatar: Icon(
                                Icons.video_call,
                                color: Colors.white,
                                size: 20,
                              ),
                              backgroundColor: kColorBlue,
                              label: Text(
                                "Video",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                getDataFile(dataBahanAjar[index]['id']);
                              });
                            },
                            child: const Chip(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              avatar: Icon(
                                Icons.file_copy_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              backgroundColor: kPrimaryColor,
                              label: Text(
                                "File",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      }),
                  SizedBox(height: 10)
                ],
              )
            : ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                children: [
                  _search(),
                  SizedBox(height: 15,),
                  ListView.separated(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount:
                          _foundUsers == null ? 0 : _foundUsers.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 5,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return _listMataPelajaran(
                          _foundUsers[index]['judul'],
                          _foundUsers[index]['keterangan'],
                          GestureDetector(
                            // onTap: () => Navigator.pushNamed(
                            //     context, InputKategoriNilai.routeName,
                            //     arguments: dataMapel[index]),
                            onTap: () {
                              setState(() {
                                getDatavideo(_foundUsers[index]['id']);
                              });
                            },
                            child: const Chip(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              avatar: Icon(
                                Icons.video_call,
                                color: Colors.white,
                                size: 20,
                              ),
                              backgroundColor: kColorBlue,
                              label: Text(
                                "Video",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                getDataFile(_foundUsers[index]['id']);
                              });
                            },
                            child: const Chip(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              avatar: Icon(
                                Icons.file_copy_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              backgroundColor: kPrimaryColor,
                              label: Text(
                                "File",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      }),
                  SizedBox(height: 10)
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

  _listMataPelajaran(
    String judul,
    String keterangan,
    GestureDetector video,
    GestureDetector file,
    // GestureDetector ubah,
  ) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      padding: EdgeInsets.all(15),
      height: 125,
      decoration: BoxDecoration(
          color: mFillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: mBorderColor, width: 1)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 160,
                child: Text(
                  judul,
                  overflow: TextOverflow.ellipsis,
                  style: (TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Icon(
                    Icons.class__rounded,
                    color: Colors.grey,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 160,
                    child: Text(
                      keterangan,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                      // width: MediaQuery.of(context).size.width - 160,
                      child: Row(
                    children: [video],
                  )),
                  const SizedBox(
                    width: 4,
                  ),
                  Container(
                      // width: MediaQuery.of(context).size.width - 160,
                      child: Row(
                    children: [file],
                  )),
                  const SizedBox(
                    width: 4,
                  ),
                  // Container(
                  //     // width: MediaQuery.of(context).size.width - 160,
                  //     child: Row(
                  //   children: [ubah],
                  // )),
                  // const SizedBox(
                  //   width: 4,
                  // ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  _popPlayVideo(id, name, link, context) {
    String linkVideo;
    linkVideo = YoutubePlayer.convertUrlToId(link)!;
    // set up the buttons
    Widget editButton = GestureDetector(
        onTap: () => {Navigator.of(context).pop()},
        child: const Chip(
          avatar: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          backgroundColor: kColorYellow,
          label: Text("Edit",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ));
    Widget hapusButton = GestureDetector(
        onTap: () =>
            {KomponenBahanAjarResponse.hapusVideoBahanAjar(id, context)},
        child: const Chip(
          avatar: Icon(
            Icons.restore_from_trash_sharp,
            color: Colors.white,
          ),
          backgroundColor: kColorRedSlow,
          label: Text("Hapus",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ));
    Widget cancelButton = GestureDetector(
        onTap: () => {Navigator.of(context).pop()},
        child: const Chip(
          avatar: Icon(
            Icons.cancel,
            color: Colors.white,
          ),
          backgroundColor: kColorRedSlow,
          label: Text("Batal",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        name,
        style: mTitleStyle16,
      ),
      content: Container(
        height: 175,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: linkVideo, //Add videoID.
                flags: YoutubePlayerFlags(
                  hideControls: false,
                  controlsVisibleAtStart: true,
                  autoPlay: false,
                  mute: false,
                ),
              ),
              showVideoProgressIndicator: true,
              progressIndicatorColor: kPrimaryColor,
            ),
          ],
        ),
      ),
      actions: [editButton, hapusButton, cancelButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
    // print(BahanMengajar.dataMapelPerIndex);
    try {
      final response = await http.get(
          "${bahanAjar}${BahanMengajar.dataMapelPerIndex['NIP']}/${BahanMengajar.dataMapelPerIndex['idMapel']}/${BahanMengajar.dataMapelPerIndex['idkelompokkls']}",
          headers: headers);
      responseJson = json.decode(response.body);
      // Future.delayed(Duration(seconds: 2)).then((value) {
      //   utilsApps.hideDialog(context);
      // });
      setState(() {
        isLoading = false;
        status = responseJson['status'];
        code = responseJson['code'];
        if (status == true && code == 200) {
          // dataBahanAjar = responseJson['result'];
          dataBahanAjar = List<Map<String, dynamic>>.from(
              json.decode(response.body)['result']);
        } else if (status == false && code == 403) {
          // AwesomeDialog(
          //         context: context,
          //         dialogType: DialogType.WARNING,
          //         animType: AnimType.RIGHSLIDE,
          //         headerAnimationLoop: true,
          //         title: 'Peringatan',
          //         desc:
          //             '${responseJson['message']}, Klik Ok untuk membuat bahan mengajar',
          //         btnOkOnPress: () {
          //           Navigator.pushNamed(context, InputBahanAjar.routeName,
          //               arguments: BahanMengajar.dataMapelPerIndex);
          //         },
          //         btnOkIcon: Icons.check,
          //         onDissmissCallback: (type) {},
          //         btnOkColor: kColorYellow)
          //     .show();
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
                      context, HomeGuru.routeName, (r) => false);
                },
                btnOkColor: kColorRedSlow)
            .show();
      });
    }

    return 'success';
  }

  Future<String> getDatavideo(id) async {
    setState(() {
      isLoadingVideo = true;
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'x-access-token': data['access_token'],
      'username': data['username']
    };

    try {
      final response =
          await http.get("${bahanAjarVideo}${id}", headers: headers);

      responseJsonVideo = json.decode(response.body);

      setState(() {
        isLoadingVideo = false;
        status = responseJsonVideo['status'];
        code = responseJsonVideo['code'];
        if (status == true && code == 200) {
          dataVideo = responseJsonVideo['result'];
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
              ),
              builder: (context) {
                return ListView(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.video,
                        color: kPrimaryColor,
                      ),
                      title: Text('Materi Video',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        // var idBahanAjar = {"idBahanAjar": id};
                        // var newData = {};
                        // newData.addAll(idBahanAjar);
                        // newData.addAll(BahanMengajar.dataMapelPerIndex);
                        // Navigator.pushNamed(context, InputVideo.routeName,
                        //     arguments: newData);
                      },
                    ),
                    Divider(
                      color: kPrimaryColor,
                    ),
                    ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: dataVideo == null ? 0 : dataVideo.length,
                        itemBuilder: (BuildContext context, int index2) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.video_call),
                                title: Text(dataVideo[index2]['judul_video'] ??
                                    'Tidak ada data'),
                                onTap: () {
                                  // print();
                                  if (dataVideo[index2]['sumber_youtube'] ==
                                      'Y') {
                                    Navigator.pushNamed(
                                        context, PlayVideo.routeName,
                                        arguments: dataVideo[index2]);
                                  } else {
                                    _launchInBrowser(
                                        '${dataVideo[index2]['link']}');
                                  }
                                },
                              ),
                            ],
                          );
                        })
                  ],
                );
              });
        } else if (status == false && code == 403) {
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
              ),
              builder: (context) {
                return ListView(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.not_interested_sharp,
                        color: kPrimaryColor,
                      ),
                      title: Text('Tidak Ada Video',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      // onTap: () {
                      //   var idBahanAjar = {"idBahanAjar": id};
                      //   var newData = {};
                      //   newData.addAll(idBahanAjar);
                      //   newData.addAll(BahanMengajar.dataMapelPerIndex);
                      //   Navigator.pushNamed(context, InputVideo.routeName,
                      //       arguments: newData);
                      // },
                    ),
                  ],
                );
              });
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
        isLoadingVideo = false;
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
                      context, HomeGuru.routeName, (r) => false);
                },
                btnOkColor: kColorRedSlow)
            .show();
      });
    }

    return 'success';
  }

  Future<String> getDataFile(id) async {
    setState(() {
      isLoadingFile = true;
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'x-access-token': data['access_token'],
      'username': data['username']
    };

    try {
      final response =
          await http.get("${bahanAjarFile}${id}", headers: headers);

      responseJsonFile = json.decode(response.body);

      setState(() {
        isLoadingFile = false;
        status = responseJsonFile['status'];
        code = responseJsonFile['code'];
        if (status == true && code == 200) {
          dataFile = responseJsonFile['result'];
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
              ),
              builder: (context) {
                return ListView(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.file,
                        color: kPrimaryColor,
                      ),
                      title: Text('Materi File',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        // var idBahanAjar = {"idBahanAjar": id};
                        // var newData = {};
                        // newData.addAll(idBahanAjar);
                        // newData.addAll(BahanMengajar.dataMapelPerIndex);
                        // Navigator.pushNamed(context, InputFile.routeName,
                        //     arguments: newData);
                      },
                    ),
                    Divider(
                      color: kPrimaryColor,
                    ),
                    ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: dataFile == null ? 0 : dataFile.length,
                        itemBuilder: (BuildContext context, int index2) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.insert_drive_file_sharp),
                                title: Text(dataFile[index2]['judul_file'] ??
                                    'Tidak ada data'),
                                onTap: () {
                                  _launchInBrowser(
                                      '${baseUrlMateriBahanFile}${dataFile[index2]['file']}');
                                },
                              ),
                            ],
                          );
                        })
                  ],
                );
              });
        } else if (status == false && code == 403) {
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
              ),
              builder: (context) {
                return ListView(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.not_interested_sharp,
                        color: kPrimaryColor,
                      ),
                      title: Text('Tidak ada File',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        // var idBahanAjar = {"idBahanAjar": id};
                        // var newData = {};
                        // newData.addAll(idBahanAjar);
                        // newData.addAll(BahanMengajar.dataMapelPerIndex);
                        // Navigator.pushNamed(context, InputFile.routeName,
                        //     arguments: newData);
                      },
                    ),
                  ],
                );
              });
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
        isLoadingVideo = false;
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
                      context, HomeGuru.routeName, (r) => false);
                },
                btnOkColor: kColorRedSlow)
            .show();
      });
    }

    return 'success';
  }

  Future<void> _launchInBrowser(String url) async {
    print(url);
    if (!url.contains('http')) url = 'https://$url';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  _search() {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.screenWidth * 0.8,
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: (value) => {_runFilter(value)},
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenWidth(9)),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "Cari Mata Pelajaran...",
            prefixIcon: Icon(Icons.search)),
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = dataBahanAjar;
    } else {
      results = dataBahanAjar
          .where((mapel) => mapel["judul"]
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();

      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
      print(_foundUsers);
    });
  }
}
