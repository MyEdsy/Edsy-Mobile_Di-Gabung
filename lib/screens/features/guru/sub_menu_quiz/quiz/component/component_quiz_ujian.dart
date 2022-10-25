import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_apps/screens/features/guru/sub_menu_quiz/quiz/detail_quiz_screens.dart';
import 'package:school_apps/screens/features/guru/sub_menu_tugas/soal_tugas/soal_screens.dart';
import 'package:school_apps/screens/features/guru/sub_menu_tugas/tugas/detail_tugas_screens.dart';
import 'package:school_apps/screens/login/login_screens.dart';
import 'package:school_apps/utils/SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../constants.dart';
import '../../../../../../main.dart';
import 'package:school_apps/server/api.dart';
import 'package:http/http.dart' as http;

import '../../../home_guru.dart';
import '../quiz_screens_.dart';
import '../update_quiz_screens.dart';

class ComponentQuiz extends StatefulWidget {
  @override
  _ComponentQuiz createState() => _ComponentQuiz();
}

class _ComponentQuiz extends State<ComponentQuiz>
    with TickerProviderStateMixin {
  var isLoading = false, isLoadingVideo = false, isLoadingFile = false;
  var responseJson, dataTugas;
  var status, code;

  AnimationController? animationController;

  var data = jsonDecode(dataUserLogin);
  var dataTahunAjaran = jsonDecode(tahunAjaranPref);

  @override
  void initState() {
    // TODO: implement initState
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
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
              child: GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, __) => (dummyListViewCell()),
                  itemCount: 10,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      childAspectRatio: 1)),
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
                itemCount: dataTugas == null ? 0 : dataTugas.length,
                shrinkWrap: true,
                primary: false,
                separatorBuilder: (BuildContext context, int index) {
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
            Navigator.pushNamed(context, DetailQuiz.routeName, arguments: {
              "NIP": MenuQuiz.dataMapelPerIndex['NIP'],
              "idMapel": MenuQuiz.dataMapelPerIndex['idMapel'],
              "idkelompokkls": MenuQuiz.dataMapelPerIndex['idkelompokkls'],
              "Namamapel": MenuQuiz.dataMapelPerIndex['Namamapel'],
              "KelompokKelas": MenuQuiz.dataMapelPerIndex['KelompokKelas'],
              "NamaKelompokKelas":
                  MenuQuiz.dataMapelPerIndex['NamaKelompokKelas'],
              "Jurusan": MenuQuiz.dataMapelPerIndex['Jurusan'],
              "nama_tugas": index['nama_tugas'],
              "keterangan": index['keterangan'],
              "tgl_mulai": index['tgl_mulai'],
              "link_youtube": index['link_youtube'],
              "link_sumberlain": index['link_sumberlain'],
              "tgl_selesai": index['tgl_selesai'],
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

  _tugasSiswaCard(
      count,
      index,
      String name,
      type,
      date_mulai,
      date_selesai,
      data,
      String imgPath,
      GestureDetector lihatSoal,
      GestureDetector edit,
      context) {
    final Animation<double> animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              // onTap: callback,
              child: SizedBox(
                  height: 280,
                  child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: InkWell(
                          onTap: () {
                            print(index);
                            // Navigator.pushNamed(context, MenuTugas.routeName,
                            //     arguments: data);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 3.0,
                                        blurRadius: 5.0)
                                  ],
                                  color: Colors.white),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 150,
                                          padding: EdgeInsets.only(left: 16),
                                          child: Text(name,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF575E67),
                                                  // fontFamily: 'Varela',
                                                  fontSize: 16.0)),
                                        )
                                      ],
                                    ),
                                    Hero(
                                        tag: index,
                                        child: Container(
                                            height: 90.0,
                                            width: 140.0,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                      imgPath,
                                                    ),
                                                    fit: BoxFit.contain)))),
                                    // SizedBox(height: 7.0),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.date_range,
                                          color: kColorTealSlow,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                          child: Text(
                                            date_mulai,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                // fontFamily: 'Varela',
                                                fontSize: 12.0),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.date_range,
                                          color: kColorRedSlow,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                          child: Text(
                                            date_selesai,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: kPrimaryColor,
                                                // fontFamily: 'Varela',
                                                fontSize: 12.0),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Container(
                                            color: Color(0xFFEBEBEB),
                                            height: 1.0)),
                                    lihatSoal,
                                    SizedBox(
                                      height: 5,
                                    ),
                                    // edit
                                  ]))))),
            ),
          ),
        );
      },
    );
  }

  Widget dummyListViewCell() {
    return Padding(
        padding:
            EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0, right: 15.0),
        child: InkWell(
            onTap: () {
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (context) => CookieDetail(
              //         assetPath: imgPath,
              //         cookieprice:price,
              //         cookiename: name
              //     )));
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3.0,
                          blurRadius: 5.0)
                    ],
                    color: Colors.white),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 45.0,
                        width: 45.0,
                      ),
                      SizedBox(height: 7.0),
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child:
                              Container(color: Color(0xFFEBEBEB), height: 1.0)),
                    ]))));
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
          "${getTugas}Quiz/${MenuQuiz.dataMapelPerIndex['NIP']}/${MenuQuiz.dataMapelPerIndex['idMapel']}/${MenuQuiz.dataMapelPerIndex['idkelompokkls']}/${dataTahunAjaran['tahunakademik']}/${dataTahunAjaran['semester']}",
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
          print('Data NYA ${dataTugas}');
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
}
