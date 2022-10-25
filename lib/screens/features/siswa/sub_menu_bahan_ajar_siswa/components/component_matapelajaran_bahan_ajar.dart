import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:school_apps/screens/features/guru/sub_menu_bahan_ajar/bahan_ajar/bahan_ajar_screen.dart';
import 'package:school_apps/screens/features/siswa/home_siswa.dart';
import 'package:school_apps/screens/features/siswa/sub_menu_bahan_ajar_siswa/bahan_ajar/bahan_ajar_screen.dart';
import 'package:school_apps/screens/login/login_screens.dart';
import 'package:school_apps/server/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../../../../../constants.dart';
import '../../../../../main.dart';
import '../../../../../size_config.dart';

class ComponentBahanAjar extends StatefulWidget {
  @override
  _ComponentBahanAjar createState() => _ComponentBahanAjar();
}

class _ComponentBahanAjar extends State<ComponentBahanAjar> {
  var isLoading = false;
  var responseJson;
  List<Map<String, dynamic>> dataMapel = [];
  List<Map<String, dynamic>> _foundUsers = [];
  var status, code;

  var data = jsonDecode(dataUserLogin);
  var dataTahunAjaran = jsonDecode(tahunAjaranPref);
  TextEditingController textController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var _crossAxisSpacing = 8;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 170;
    var _aspectRatio = _width / cellHeight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, top: 10, bottom: 12),
          child: Text(
            'Bahan Mengajar',
            style: mTitleStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
          child: isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Shimmer.fromColors(
                    baseColor: mGreyColor,
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
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        _search(),
                        SizedBox(height: 10,),
                        ListView.separated(
                          itemCount: dataMapel == null ? 0 : dataMapel.length,
                          shrinkWrap: true,
                          primary: false,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 5,
                            );
                          },
                          itemBuilder: (context, index) {
                            return _buildCard2(
                                dataMapel[index]['Namamapel'],
                                '${dataMapel[index]['Nama']} ${dataMapel[index]['Gelarbelakang'] ?? ''}',
                                dataMapel[index],
                                '${index}',
                                'assets/images/education.png',
                                false,
                                false,
                                context);
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
                        SizedBox(height: 10,),
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
                                _foundUsers[index]['Namamapel'],
                                '${_foundUsers[index]['Nama']} ${_foundUsers[index]['Gelarbelakang'] ?? ''}',
                                _foundUsers[index],
                                '${index}',
                                'assets/images/education.png',
                                false,
                                false,
                                context);
                          },
                        ),
                        SizedBox(height: 15.0)
                      ],
                    ),
        )
      ],
    );
  }

  Widget _buildCard2(String name, String pengajar, data, String index,
      String imgPath, bool added, bool isFavorite, context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: GestureDetector(
          onTap: () => Navigator.pushNamed(
              context, BahanMengajarSiswa.routeName,
              arguments: data),
          child: Container(
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.only(left: 16),
            height: 80,
            decoration: BoxDecoration(
              color: mFillColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: mBorderColor, width: 1),
            ),
            child: Row(
              children: <Widget>[
                Image.asset(
                  imgPath,
                  width: 32,
                  height: 32,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: getProportionateScreenWidth(250),
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: mServiceTitleStyle,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(pengajar, style: mServiceSubtitleStyle)
                    ],
                  ),
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
            hintText: "Cari Mata Pelajaran...",
            prefixIcon: Icon(Icons.search)),
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = dataMapel;
    } else {
      results = dataMapel
          .where((mapel) => mapel["Namamapel"]
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
          "${jadwalSiswaByNisn}${data['username']}/${dataTahunAjaran['tahunakademik']}/${dataTahunAjaran['semester']}",
          headers: headers);
      responseJson = json.decode(response.body);
      setState(() {
        isLoading = false;
        status = responseJson['status'];
        code = responseJson['code'];
        if (status == true && code == 200) {
          dataMapel = List<Map<String, dynamic>>.from(
              json.decode(response.body)['result']);
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
}