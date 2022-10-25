import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_apps/screens/OnBoarding/OnBoarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../constants.dart';
import '../../../../../main.dart';
import '../../home_guru.dart';
import 'package:school_apps/server/api.dart';
import 'package:http/http.dart' as http;

import '../Screens/ScreenDataQuiz.dart';
import '../Screens/ScreenDetailStatistikQuiz.dart';

class ComponentQuiz extends StatefulWidget {
  @override
  _ComponentQuiz createState() => _ComponentQuiz();
}

class _ComponentQuiz extends State<ComponentQuiz> {

  var isLoading = false, isLoadingVideo = false, isLoadingFile = false;
  var responseJson, dataTugas;
  var status, code;

  AnimationController? animationController;

  var data = jsonDecode(dataUserLogin);
  var dataTahunAjaran = jsonDecode(tahunAjaranPref);

  @override
  void initState() {
    // TODO: implement initState
    // animationController = AnimationController(
    //     duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
        baseColor: mGreyColor,
        highlightColor: mGreyColor,
        child: ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, __) => (dummyListViewCell()),
          itemCount: 20,
        ),
      ),
    )
        :
    ListView(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: <Widget>[
        // _search(),
        SizedBox(
          height: 10,
        ),
        ListView.separated(
          itemCount:
          dataTugas == null ? 0 : dataTugas.length,
          shrinkWrap: true,
          primary: false,
          separatorBuilder:
              (BuildContext context, int index) {
            return SizedBox(
              height: 5,
            );
          },
          itemBuilder: (context, index) {
            return _buildCard2(
                dataTugas[index]['nama_tugas'],
                '${parseDateIndo2(dataTugas[index]['tglMulai'])}',
                '${parseDateIndo2(dataTugas[index]['tglSelesai'])}',
                dataTugas[index],
                'assets/images/learn.png',
                false,
                false,
                context,
                dataTugas[index]['status']);
          },
        ),
        SizedBox(height: 15.0)
      ],
    );
  }


  Widget _buildCard2(String name, String tglMulai, String tglSelesai, var index,
      String imgPath, bool added, bool isFavorite, context, status) {

    return Row(
      children: <Widget>[
        Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, StatistikQuiz.routeName, arguments: {
                  "nama_tugas": index['nama_tugas'],
                  "keterangan": index['keterangan'],
                  "link_youtube": index['link_youtube'],
                  "link_sumberlain": index['link_sumberlain'],
                  "tglMulai": index['tglMulai'],
                  "tglSelesai": index['tglSelesai'],
                  "id": index['id']
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 10, left: 10),
                // padding: EdgeInsets.only(left: 16),
                height: 90,
                decoration: BoxDecoration(
                  color: mFillColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: mBorderColor, width: 1),
                ),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      imgPath,
                      width: 72,
                      height: 72,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            name,
                            style: mServiceTitleStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(Icons.date_range_sharp,
                                  size: 15, color: kPrimaryColor),
                              SizedBox(
                                width: 5,
                              ),
                              Text(tglMulai, style: mServiceSubtitleStyle),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.flagCheckered,
                                  size: 15, color: kPrimaryColor),
                              SizedBox(
                                width: 5,
                              ),
                              Text(tglSelesai, style: mServiceSubtitleStyle)
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          status == 'Belum Dimulai'
                              ? Row(
                            children: [
                              Container(
                                width: 15,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(5),
                                    )),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(status, style: mServiceSubtitleStyle)
                            ],
                          )
                              : status == 'Sedang Berjalan'
                              ? Row(
                            children: [
                              Container(
                                width: 15,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: kColorTealToSlow,
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(5),
                                    )),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(status, style: mServiceSubtitleStyle)
                            ],
                          )
                              : Row(
                            children: [
                              Container(
                                width: 15,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(5),
                                    )),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(status, style: mServiceSubtitleStyle)
                            ],
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, color: kPrimaryColor),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ),
            )),
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
      final response = await http.get(
          "${getTugas}Quiz/${data['username']}/${ScreenDataQuiz.dataMapelPerIndex['idMapel']}/${ScreenDataQuiz.dataMapelPerIndex['idkelompokkls']}/${dataTahunAjaran['tahunakademik']}/${dataTahunAjaran['semester']}",
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
          dataTugas = responseJson['result'];
        } else if (status == false && code == 403) {
          AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: true,
              title: 'Peringatan',
              desc: '${responseJson['message']}',
              btnOkOnPress: () {
                // Navigator.pushNamed(context, InputBahanAjar.routeName,
                //     arguments: BahanMengajar.dataMapelPerIndex);
              },
              btnOkIcon: Icons.check,
              onDissmissCallback: (type) {},
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
                    context, Onboarding.routerName, (r) => false);
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
}
