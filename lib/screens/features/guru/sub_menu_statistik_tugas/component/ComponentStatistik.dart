import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:school_apps/constants.dart';
import 'package:school_apps/screens/OnBoarding/OnBoarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../main.dart';
import '../../../../../server/api.dart';
import '../../home_guru.dart';
import '../model/nilaiModel.dart';
import '../screeens/ScreenStatistikTugas.dart';
import '../screeens/StatistikDetailScreens.dart';
import 'package:http/http.dart' as http;

class BarChart extends StatefulWidget {
  @override
  _BarChart createState() => _BarChart();
}

class _BarChart extends State<BarChart> {
  List<NilaiModel> nilai = [];
  var isLoading = false;
  var responseJson;
  var status, code;

  // List<Map<String, dynamic>> dataStatistik = [];
  List<Map<String, dynamic>> _foundUsers = [];
  var dataStatistik, daftarNilaiSiswa;

  var data = jsonDecode(dataUserLogin);
  var dataTahunAjaran = jsonDecode(tahunAjaranPref);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(StatistikTugas.dataTugas['id']);
  }

  List<charts.Series<NilaiModel, String>> _createSampleData() {
    return [
      charts.Series<NilaiModel, String>(
        data: nilai,
        id: 'sales',
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
        domainFn: (NilaiModel nilai, _) => nilai.nilai,
        measureFn: (NilaiModel nilai, _) => nilai.jumlah,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: [
            Text("${SubMenuMataStatistikTugas.dataMapelPerIndex['Namamapel']}",
                style: mTitleStyle),
            Text("${SubMenuMataStatistikTugas.dataMapelPerIndex['Kodekelas']}",
                style: mTitleStyle),
            Text("${StatistikTugas.dataTugas['nama_tugas']}",
                style: mTitleStyle),
            SizedBox(
              height: 20,
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Text("Distribusi Nilai", style: mTitleStyle),
                        Container(
                          height: 300,
                          child: charts.BarChart(
                            _createSampleData(),
                            animate: true,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Statistik Nilai Dan Pengerjaan",
                              style: mTitleStyle,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.only(right: 8),
                                padding: EdgeInsets.only(left: 16),
                                height: 64,
                                // color: kPrimaryColor,
                                decoration: BoxDecoration(
                                  color: mFillColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: mBorderColor, width: 1),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.arrow_circle_up),
                                    Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Nilai Tertinggi',
                                            style: mServiceTitleStyle,
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text('${dataStatistik['maxScore']}',
                                              style: mTitleStyle)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                            Expanded(
                                child: GestureDetector(
                              // onTap: () => Navigator.pushNamed(
                              //     context, SubMenuPresensiKelas.routeName),
                              child: Container(
                                margin: EdgeInsets.only(left: 8),
                                padding: EdgeInsets.only(left: 16),
                                height: 64,
                                decoration: BoxDecoration(
                                  color: mFillColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: mBorderColor, width: 1),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.arrow_circle_down),
                                    Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Nilai Terendah',
                                            style: mServiceTitleStyle,
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text('${dataStatistik['minScore']}',
                                              style: mTitleStyle)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.only(right: 8),
                                padding: EdgeInsets.only(left: 16),
                                height: 64,
                                // color: kPrimaryColor,
                                decoration: BoxDecoration(
                                  color: mFillColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: mBorderColor, width: 1),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.bar_chart_sharp),
                                    Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Nilai Rata-rata',
                                            style: mServiceTitleStyle,
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text('${dataStatistik['avgScore']}',
                                              style: mTitleStyle)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: GestureDetector(
                              // onTap: () => Navigator.pushNamed(
                              //     context, SubMenuPresensiKelas.routeName),
                              child: Container(
                                margin: EdgeInsets.only(left: 8),
                                padding: EdgeInsets.only(left: 16),
                                height: 64,
                                decoration: BoxDecoration(
                                  color: mFillColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: mBorderColor, width: 1),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.access_time_outlined),
                                    Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Tepat Waktu',
                                            style: mServiceTitleStyle,
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              '${dataStatistik['tepatWaktu']}/${dataStatistik['jumlahSiswa']}',
                                              style: mTitleStyle)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.only(right: 8),
                                padding: EdgeInsets.only(left: 16),
                                height: 64,
                                // color: kPrimaryColor,
                                decoration: BoxDecoration(
                                  color: mFillColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: mBorderColor, width: 1),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.timer_off),
                                    Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Telat',
                                            style: mServiceTitleStyle,
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              '${dataStatistik['telat']}/${dataStatistik['jumlahSiswa']}',
                                              style: mTitleStyle)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.only(right: 8),
                                padding: EdgeInsets.only(left: 16),
                                height: 64,
                                // color: kPrimaryColor,
                                decoration: BoxDecoration(
                                  color: mFillColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: mBorderColor, width: 1),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.file_copy_sharp),
                                    Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Total Terkumpul',
                                            style: mServiceTitleStyle,
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              '${dataStatistik['totalTerkumpul']}/${dataStatistik['jumlahSiswa']}',
                                              style: mTitleStyle)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                            Expanded(
                                child: GestureDetector(
                              // onTap: () => Navigator.pushNamed(
                              //     context, SubMenuPresensiKelas.routeName),
                              child: Container(
                                margin: EdgeInsets.only(left: 8),
                                padding: EdgeInsets.only(left: 16),
                                height: 64,
                                decoration: BoxDecoration(
                                  color: mFillColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: mBorderColor, width: 1),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.more_time_sharp),
                                    Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Belum Dikerjakan',
                                            style: mServiceTitleStyle,
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              '${dataStatistik['belumMengerjakan']}/${dataStatistik['jumlahSiswa']}',
                                              style: mTitleStyle)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: GestureDetector(
                              // onTap: () => Navigator.pushNamed(
                              //     context, SubMenuPresensiKelas.routeName),
                              child: Container(
                                margin: EdgeInsets.only(left: 8),
                                padding: EdgeInsets.only(left: 16),
                                height: 64,
                                decoration: BoxDecoration(
                                  color: mFillColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: mBorderColor, width: 1),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.done),
                                    Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Telah Dinilai',
                                            style: mServiceTitleStyle,
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              '${dataStatistik['sudahDinilai']}',
                                              style: mTitleStyle)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: GestureDetector(
                              // onTap: () => Navigator.pushNamed(
                              //     context, SubMenuPresensiKelas.routeName),
                              child: Container(
                                // margin: EdgeInsets.only(left: 8),
                                padding: EdgeInsets.only(left: 16),
                                height: 64,
                                decoration: BoxDecoration(
                                  color: mFillColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: mBorderColor, width: 1),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.close),
                                    Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Belum Dinilai',
                                            style: mServiceTitleStyle,
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              '${dataStatistik['belumDinilai']}',
                                              style: mTitleStyle)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ))
                          ],
                        ),
                      SizedBox(
                        height: 25,
                      ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Daftar Nilai Siswa",
                              style: mTitleStyle,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ListView(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            ListView.separated(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: daftarNilaiSiswa == null
                                    ? 0
                                    : daftarNilaiSiswa.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 5,
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return _nilaiSiswa(
                                      '${daftarNilaiSiswa[index]['nisn']}',
                                      '${daftarNilaiSiswa[index]['nama']}',
                                      '${daftarNilaiSiswa[index]['nilai']}');
                                }),
                            SizedBox(height: 10)
                          ],
                        )
                      ]),
          ],
        ));
  }

  _nilaiSiswa(nisn, nama, nilai) {
    return Container(
        // margin: EdgeInsets.only(left: 16, right: 16),
        padding: EdgeInsets.all(10),
        height: 100,
        decoration: BoxDecoration(
            color: mFillColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: mBorderColor, width: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 160,
              child: Text(
                nisn,
                overflow: TextOverflow.ellipsis,
                style: (TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.grey,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 160,
                  child: Text(
                    nama,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.description,
                  color: Colors.grey,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: 200,
                  child: Text(
                    nilai,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Future<String> getData(id) async {
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
      final response =
          await http.get("${getStatistikTugas}/$id", headers: headers);
      responseJson = json.decode(response.body);
      // Future.delayed(Duration(seconds: 2)).then((value) {
      //   utilsApps.hideDialog(context);
      // });
      setState(() {
        isLoading = false;
        status = responseJson['status'];
        code = responseJson['code'];
        if (status == true && code == 200) {
          dataStatistik = responseJson['result'];
          List<NilaiModel> tempdata = genderModelFromJson(
              json.encode(dataStatistik['distribusiNilaiJml']));
          daftarNilaiSiswa = dataStatistik['daftarNilaiSiswa'];
          setState(() {
            nilai = tempdata;
          });
        } else if (status == false && code == 403) {
          dataStatistik = {
            "maxScore": 0,
            "minScore": 0,
            "avgScore": 0,
            "jumlahSiswa": 0,
            "tepatWaktu": 0,
            "telat": 0,
            "belumMengerjakan": 0,
            "totalTerkumpul": 0,
            "sudahDinilai": 0,
            "belumDinilai": 0,
          };
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
                        context, HomeGuru.routeName, (r) => false);
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
        // AwesomeDialog(
        //     context: context,
        //     dialogType: DialogType.ERROR,
        //     animType: AnimType.RIGHSLIDE,
        //     headerAnimationLoop: true,
        //     title: 'Peringatan',
        //     desc: "Tidak dapat terhububg ke server",
        //     btnOkOnPress: () {},
        //     btnOkIcon: Icons.cancel,
        //     onDissmissCallback: (type) async {
        //       //SignInScreen
        //       Navigator.pushNamedAndRemoveUntil(
        //           context, HomeGuru.routeName, (r) => false);
        //     },
        //     btnOkColor: kColorRedSlow)
        //     .show();
      });
    }

    return 'success';
  }
}
