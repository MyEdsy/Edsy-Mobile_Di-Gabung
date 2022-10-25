import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_apps/screens/features/guru/sub_menu_tugas/soal_tugas/soal_screens.dart';
import 'package:school_apps/screens/features/guru/sub_menu_tugas/tugas/response/response_tugas.dart';
import 'package:school_apps/screens/login/login_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../constants.dart';
import '../../../../../../main.dart';
import 'package:school_apps/server/api.dart';
import 'package:http/http.dart' as http;

import '../../../home_guru.dart';
import '../detail_tugas_screens.dart';

class ComponentDetailTugas extends StatefulWidget {
  @override
  _ComponentBahanAjar createState() => _ComponentBahanAjar();
}

class _ComponentBahanAjar extends State<ComponentDetailTugas> {
  var isLoading = false, isLoadingVideo = false, isLoadingFile = false;
  var responseJson,
      dataDetailTugas;
  var status, code;

  var data = jsonDecode(dataUserLogin);
  var dataTahunAjaran = jsonDecode(tahunAjaranPref);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getData();
    });
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
        : ListView(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      children: [
        ListView.separated(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: dataDetailTugas == null ? 0 : dataDetailTugas.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 5,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return _listMataPelajaran(
                '${dataDetailTugas[index]['type']}',
                'Jumlah Soal : ${dataDetailTugas[index]['jumlahSoal'] ?? "-"}',
                GestureDetector(
                  onTap: () {
                    // var bahanAjar = {"bahanAjar": dataBahanAjar[index]};
                    // var newData = {};
                    // newData.addAll(bahanAjar);
                    // newData.addAll(BahanMengajar.dataMapelPerIndex);
                    Navigator.pushNamed(
                        context, SoalTugas.routeName,
                        arguments: {
                          "idDetailSoal": dataDetailTugas[index]['id'],
                          "keterangan": DetailTugas.dataTugasFromDetailTugas['keterangan'],
                          "idTugas": DetailTugas.dataTugasFromDetailTugas['id'],
                          "type": dataDetailTugas[index]['type'],
                          "nama_tugas": DetailTugas.dataTugasFromDetailTugas['nama_tugas'],
                          "tglMulai": DetailTugas.dataTugasFromDetailTugas['tglMulai'],
                          "tglSelesai": DetailTugas.dataTugasFromDetailTugas['tglSelesai'],
                          "link_youtube": DetailTugas.dataTugasFromDetailTugas['link_youtube'],
                          "link_sumberlain": DetailTugas.dataTugasFromDetailTugas['link_sumberlain'],
                        });
                  },
                  child: const Chip(
                    materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
                    avatar: Icon(
                      Icons.wysiwyg_sharp,
                      color: Colors.white,
                      size: 20,
                    ),
                    backgroundColor: kColorTealSlow,
                    label: Text(
                      "Lihat Soal",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {

                    var jumlahSoal = '0';
                    if(dataDetailTugas[index]['type'] == 'File'){
                      jumlahSoal = '1';
                    }else if(dataDetailTugas[index]['type'] == 'Essay'){
                      jumlahSoal = '${dataDetailTugas[index]['jumlahSoal']}';
                    }else {
                      jumlahSoal = '0';
                    }
                    var kirimData = {
                      "idDetailSoal": dataDetailTugas[index]['id'],
                      "jumlahSoal": jumlahSoal,
                      "idTugas" : '${DetailTugas.dataTugasFromDetailTugas['id']}',
                      "bobot" : '${dataDetailTugas[index]['bobot']}',
                    };
                    // print(kirimData);
                    KomponenTugasResponse.konfirmasiPemeriksaanRes(kirimData, context);
                  },
                  child: const Chip(
                    materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
                    avatar: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                    backgroundColor: kColorBlue,
                    label: Text(
                      "Done",
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
      String typeSoal,
      String jumlahSoal,
      GestureDetector lihatSoal,
      GestureDetector konfirm,
      ) {
    //|| typeSoal == 'File'
    if(typeSoal == 'Essay' || typeSoal == 'File') {
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
                    typeSoal,
                    overflow: TextOverflow.ellipsis,
                    style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.coins,
                      color: Colors.grey,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 160,
                      child: Text(
                        jumlahSoal,
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
                          children: [
                            lihatSoal,
                            SizedBox(width: 5,),
                            konfirm
                          ],
                        )),
                    const SizedBox(
                      width: 4,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      );
    }else {
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
                    typeSoal,
                    overflow: TextOverflow.ellipsis,
                    style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.coins,
                      color: Colors.grey,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 160,
                      child: Text(
                        jumlahSoal,
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
                          children: [
                            lihatSoal,
                          ],
                        )),
                    const SizedBox(
                      width: 4,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      );
    }
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
          "${getdetailTugas}${DetailTugas.dataTugasFromDetailTugas['id']}",
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
          dataDetailTugas = responseJson['result'];
        } else if (status == false && code == 403) {
          AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: true,
              title: 'Peringatan',
              desc:
              '${responseJson['message']}, Klik Ok untuk membuat soal',
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
