import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar_week/calendar_week.dart';
import 'package:flutter_calendar_week/model/decoration_item.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:school_apps/components/slider_no_jadwal.dart';
import 'package:school_apps/screens/login/login_screens.dart';
import 'package:school_apps/server/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../constants.dart';
import 'package:http/http.dart' as http;

import '../../../../../main.dart';
import '../../home_guru.dart';
//untuk di gabung
class JadwalPelajaran extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<JadwalPelajaran> {
  late DateTime _selectedDate;

  var isLoading = false, isLoading2 = false;
  var responseJson, responseJson2, dataMapel, dataSiswaAbsen;
  var code, code2;
  late bool status = false, status2 = false;

  var data = jsonDecode(dataUserLogin);
  var dataTahunAjaran = jsonDecode(tahunAjaranPref);
  var date = DateTime.now();
  var test;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getData(date.day, date.month, date.year);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey),
                  SizedBox(
                    width: 15,
                  ),
                  RichText(
                    text: TextSpan(
                        text: '${perseDate()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF263064),
                          fontSize: 22,
                        ),
                        children: [
                          TextSpan(
                            text: "",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
              Text(
                "Hari ${nameDay(date)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF3E3993),
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 70,
          child: Container(
            height: MediaQuery.of(context).size.height - 90,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                calendar(),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        isLoading
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Shimmer.fromColors(
                                  baseColor: mGreyColor,
                                  highlightColor: mGreyColor,
                                  child: ListView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (_, __) =>
                                        (dummyListViewCell()),
                                    itemCount: 10,
                                  ),
                                ),
                              )
                            : dataMapel.length > 0
                                ? _data()
                                : SliderNoJadwal()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  _data() {
    return ListView(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      children: [
        ListView.separated(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: dataMapel == null ? 0 : dataMapel.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 5,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              var gelarDpn;
              if (dataMapel[index]['Gelardepan'] == null) {
                gelarDpn = '';
              } else {
                gelarDpn = dataMapel[index]['Gelardepan'] + ' ';
              }
              return _getJadwal(
                  '${dataMapel[index]['Hari']}',
                  '${dataMapel[index]['JamMulai']}',
                  '${dataMapel[index]['JamSelesai']}',
                  '${dataMapel[index]['Namamapel']}',
                  '$gelarDpn ${dataMapel[index]['Nama']} ${dataMapel[index]['Gelarbelakang'] ?? ''}',
                  '${dataMapel[index]['KelompokKelas']} ${dataMapel[index]['Jurusan']} ${dataMapel[index]['NamaKelompokKelas']}',
                  dataMapel[index]['adaKelas'],
                  '${dataMapel[index]['Namakelas']}',
                  '${dataMapel[index]['statusAbsen']}',
                  dataMapel[index]);
              // buildTaskListItem(dataMapel[index]['Namamapel'], '${dataMapel[index]['JamMulai']} - ${dataMapel[index]['JamMulai']}', " ");
            }),
        SizedBox(height: 10)
      ],
    );
  }

  _getJadwal(hari, jamAwal, jamAkhir, mapel, guru, kelas, adaKelas, ruang,
      statusAbsen, index) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Column(
        children: [
          Row(
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
                width: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: '${hari} ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: '${jamAwal} - ${jamAkhir}',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusAbsen == 'Belum Absen'
                                ? kColorRedSlow
                                : kColorTealToSlow))
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
                // border: Border.all(width: 1, color: Colors.grey[300]),
                borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.only(right: 10, left: 30),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mapel,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.person,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guru,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ruang,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusAbsen,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: statusAbsen == 'Belum Absen'
                                ? kColorRedSlow
                                : kColorTealToSlow,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    statusAbsen == 'Belum Absen'
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              getDetailAbsen(
                                  index['idMapel'],
                                  index['NamaKelompokKelas'],
                                  index['NIP'],
                                  index['Tahun'],
                                  index['Semester'],
                                  index['idsetjadwal']);
                            },
                            child: Container(
                              child: Chip(
                                padding: EdgeInsets.all(0),
                                backgroundColor: kColorTealToSlow,
                                label: Text('DETAIL ABSEN',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          )
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future detailBanner() async {
    return showBarModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      builder: (context) {
        return ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: kPrimaryColor,
              height: 50,
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Text(
                "Berita Acara",
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 5, left: 10),
              child: Text(
                  "${dataSiswaAbsen[0]['berita_acara']}",
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              color: kPrimaryColor,
              height: 50,
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Text(
                "Daftar Siswa Tidak Hadir",
                style: TextStyle(
                  color: Colors.white,
                  // fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ListView.separated(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: dataSiswaAbsen == null ? 0 : dataSiswaAbsen.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 5,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return dataSiswaAbsen[index]['statusAbsen'] != 'Hadir'
                      ? Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(dataSiswaAbsen[index]['nis'],style: TextStyle(fontSize: 16),),
                              Text(dataSiswaAbsen[index]['nama_siswa'], style: TextStyle(fontSize: 16),),
                              Text(
                                dataSiswaAbsen[index]['statusAbsen'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container();
                  // buildTaskListItem(dataMapel[index]['Namamapel'], '${dataMapel[index]['JamMulai']} - ${dataMapel[index]['JamMulai']}', " ");
                })
          ],
        );
      },
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

  Widget calendar() {
    // var date = DateTime.now();
    // print(nameDay(date));
    return Container(
      // decoration: BoxDecoration(
      //     color: Color(0xff402fcc), borderRadius: BorderRadius.circular(10)),
      height: 55,
      width: double.infinity,
      child: CalendarWeek(
        // height: 55,
        minDate: DateTime.now().add(
          Duration(days: -10),
        ),
        maxDate: DateTime.now().add(
          Duration(days: 10),
        ),
        onDatePressed: (DateTime datetime) {
          setState(() {
            setState(() {
              _selectedDate = datetime;
              getData(datetime.day, datetime.month, datetime.year);
            });
          });
        },
        onDateLongPressed: (DateTime datetime) {
          setState(() {
            _selectedDate = datetime;
          });
        },
        dayOfWeekStyle: TextStyle(color: Colors.grey, fontSize: 12),
        dayOfWeekAlignment: FractionalOffset.bottomCenter,
        dateStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        dateAlignment: FractionalOffset.topCenter,
        todayDateStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        todayBackgroundColor: Color(0xff402fcc),
        pressedDateBackgroundColor: Colors.blue,
        pressedDateStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        dateBackgroundColor: Colors.transparent,
        backgroundColor: Colors.white,
        dayOfWeek: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
        spaceBetweenLabelAndDate: 2,
        dayShapeBorder: CircleBorder(),
        decorations: [
          DecorationItem(
            decorationAlignment: FractionalOffset.bottomRight,
            date: DateTime.now(),
          ),
        ],
      ),
    );
  }

  Future<String> getData(tgl, bulan, tahun) async {
    setState(() {
      isLoading = true;
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'x-access-token': data['access_token'],
      'username': data['username']
    };
    print('${jadwalGuruDanStatusAbsen}$tgl/$bulan/$tahun/${data['username']}');
    //print("${jadwalSiswaByNipGuru}${AbsenKelasScreen.dataMapel['idMapel']}/${AbsenKelasScreen.dataMapel['NamaKelompokKelas']}/${AbsenKelasScreen.dataMapel['nip']}/${AbsenKelasScreen.dataMapel['Tahun']}/${AbsenKelasScreen.dataMapel['Semester']}?id_set_jadwal=${AbsenKelasScreen.dataMapel['id_setting_jadwal']}");
    try {
      final response = await http.get(
          "${jadwalGuruDanStatusAbsen}$tgl/$bulan/$tahun/${data['username']}",
          headers: headers);
      responseJson = json.decode(response.body);

      setState(() {
        isLoading = false;
        status = responseJson['status'];
        code = responseJson['code'];
        if (status == true && code == 200) {
          dataMapel = responseJson['result'];
        } else if (status == false && code == 403) {
          dataMapel = [];
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
      if (mounted) {
        setState(() {
          status = false;
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
    }

    return 'success';
  }

  Future<String> getDetailAbsen(
      idMapel, namaKelompokKelas, nip, tahun, semester, idSetJadwal) async {
    setState(() {
      isLoading2 = true;
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'x-access-token': data['access_token'],
      'username': data['username']
    };

    try {
      final response = await http.get(
          "${jadwalSiswaByNipGuru}${idMapel}/${namaKelompokKelas}/${nip}/${tahun}/${semester}?id_set_jadwal=${idSetJadwal}",
          headers: headers);
      responseJson2 = json.decode(response.body);

      setState(() {
        isLoading2 = false;
        status2 = responseJson2['status'];
        code2 = responseJson2['code'];
        if (status2 == true && code2 == 200) {
          // dataSiswaAbsen = responseJson['result'];
          dataSiswaAbsen = List<Map<String, dynamic>>.from(
              json.decode(response.body)['result']);
          detailBanner();
          // print(dataSiswaAbsen);
        } else if (status2 == false && code2 == 403) {
          // totalKelas = responseJson['total'];
        } else {}
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          status = false;
          isLoading = false;
        });
      }
    }

    return 'success';
  }
}
