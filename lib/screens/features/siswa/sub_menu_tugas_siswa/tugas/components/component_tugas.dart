import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_apps/screens/features/guru/sub_menu_tugas/soal_tugas/soal_screens.dart';
import 'package:school_apps/screens/features/guru/sub_menu_tugas/tugas/detail_tugas_screens.dart';
import 'package:school_apps/screens/features/guru/sub_menu_tugas/tugas/tugas_screens.dart';
import 'package:school_apps/screens/features/siswa/home_siswa.dart';
import 'package:school_apps/screens/login/login_screens.dart';
import 'package:school_apps/utils/SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../constants.dart';
import '../../../../../../main.dart';
import 'package:school_apps/server/api.dart';
import 'package:http/http.dart' as http;

import '../../../../../../size_config.dart';
import '../detail_tugas_screens.dart';
import '../tugas_screens.dart';

class ComponentTugas extends StatefulWidget {
  @override
  _ComponentTugas createState() => _ComponentTugas();
}

class _ComponentTugas extends State<ComponentTugas>
    with TickerProviderStateMixin {
  var isLoading = false, isLoadingVideo = false, isLoadingFile = false;
  var responseJson;
  var status, code;

  List<Map<String, dynamic>> _foundUsers = [];
  List<Map<String, dynamic>> dataTugas = [];

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
              child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, __) => (dummyListViewCell()),
                itemCount: 20,
              ),
            ),
          )
        : _foundUsers.isEmpty
            ? ListView(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  _search(),
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
                      // print('${parseDateIndo(dataTugas[index]['tgl_mulai'])}');
                      return _buildCard2(
                          dataTugas[index]['nama_tugas'],
                          '${parseDateIndo2(dataTugas[index]['tglMulai'])}',
                          '${parseDateIndo2(dataTugas[index]['tglSelesai'])}',
                          dataTugas[index],
                          'assets/images/learn.png',
                          false,
                          false,
                          context,
                          dataTugas[index]['status'],
                          dataTugas[index]['nilai'], Color(int.parse(
                          dataTugas[index]
                          ['color'])),
                          dataTugas[index]['statusPengerjaan']);
                    },
                  ),
                  SizedBox(height: 15.0)
                ],
              )
            : ListView(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  _search(),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.separated(
                    itemCount: _foundUsers == null ? 0 : _foundUsers.length,
                    shrinkWrap: true,
                    primary: false,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 5,
                      );
                    },
                    itemBuilder: (context, index) {
                      return _buildCard2(
                          _foundUsers[index]['nama_tugas'],
                          '${parseDateIndo2(_foundUsers[index]['tglMulai'])}',
                          '${parseDateIndo2(_foundUsers[index]['tglSelesai'])}',
                          _foundUsers[index],
                          'assets/images/learn.png',
                          false,
                          false,
                          context,
                          _foundUsers[index]['status'],
                          _foundUsers[index]['nilai'],
                      Color(int.parse(
                      _foundUsers[index]
                      ['color'])),
                          _foundUsers[index]['statusPengerjaan']);
                    },
                  ),
                  SizedBox(height: 15.0)
                ],
              );
  }

  Widget _buildCard2(String name, String tglMulai, String tglSelesai, var index,
      String imgPath, bool added, bool isFavorite, context, status, nilai, color, statusNilai) {
    return Row(
      children: <Widget>[
        Expanded(
            child: GestureDetector(
          onTap: () {
            if (index['bolehUjian'] == true) {
              Navigator.pushNamed(context, DetailTugasSiswa.routeName,
                  arguments: {
                    "NIP": MenuTugasSiswa.dataMapelPerIndex['Nip'],
                    "idMapel": MenuTugasSiswa.dataMapelPerIndex['idMapel'],
                    "idkelompokkls":
                        MenuTugasSiswa.dataMapelPerIndex['idkelompokkls'],
                    "Namamapel": MenuTugasSiswa.dataMapelPerIndex['Namamapel'],
                    "KelompokKelas":
                        MenuTugasSiswa.dataMapelPerIndex['KelompokKelas'],
                    "NamaKelompokKelas":
                        MenuTugasSiswa.dataMapelPerIndex['NamaKelompokKelas'],
                    "Jurusan": MenuTugasSiswa.dataMapelPerIndex['Jurusan'],
                    "nama_tugas": index['nama_tugas'],
                    "keterangan": index['keterangan'],
                    "link_youtube": index['link_youtube'],
                    "link_sumberlain": index['link_sumberlain'],
                    "tgl_selesai": index['tgl_selesai'],
                    "id": index['id']
                  });
            } else {
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.WARNING,
                      animType: AnimType.RIGHSLIDE,
                      headerAnimationLoop: true,
                      title: 'Peringatan',
                      desc:
                          'Tidak dapat mengikuti ujian, Karena waktu ujian belum dimulai',
                      btnOkOnPress: () {
                        // Navigator.pushNamed(context, InputBahanAjar.routeName,
                        //     arguments: BahanMengajar.dataMapelPerIndex);
                      },
                      btnOkIcon: Icons.check,
                      onDissmissCallback: (type) {},
                      btnOkColor: kColorYellow)
                  .show();
            }
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
                  height: 52,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          // padding: new EdgeInsets.only(right: 13.0),
                          width: 140,
                          child: new Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: mServiceTitleStyle
                          ),
                        ),
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
                                ),
                    ],
                  ),
                ),
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nilai", style: mServiceTitleStyle),
                    SizedBox(height: 5),
                    Text("$nilai", style: mServiceSubtitleStyle,),
                    Row(
                      children: [
                        Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "$statusNilai",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 20,),
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

  _search() {
    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      width: SizeConfig.screenWidth * 0.8,
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
            hintText: "Cari Tugas...",
            prefixIcon: Icon(Icons.search)),
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = dataTugas;
    } else {
      results = dataTugas
          .where((tugas) => tugas["nama_tugas"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();

      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
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
          "${getTugas}Tugas/${MenuTugasSiswa.dataMapelPerIndex['Nip']}/${MenuTugasSiswa.dataMapelPerIndex['idMapel']}/${MenuTugasSiswa.dataMapelPerIndex['idkelompokkls']}/${dataTahunAjaran['tahunakademik']}/${dataTahunAjaran['semester']}?nisn=${data['username']}",
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
          dataTugas = List<Map<String, dynamic>>.from(
              json.decode(response.body)['result']);
          // print(dataTugas);
        } else if (status == false && code == 403) {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Peringatan',
                  desc:
                      '${responseJson['message']}',
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
                      context, HomeSiswa.routeName, (r) => false);
                },
                btnOkColor: kColorRedSlow)
            .show();
      });
    }

    return 'success';
  }
}
