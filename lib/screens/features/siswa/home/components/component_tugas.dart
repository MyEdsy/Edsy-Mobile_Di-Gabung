import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school_apps/components/pilihanGanda.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../components/buttonTabs.dart';
import '../../../../../constants.dart';
import '../../../../../main.dart';
import '../../../../../server/api.dart';

import 'package:http/http.dart' as http;

import '../../../../login/login_screens.dart';
import '../../home_siswa.dart';
import '../../sub_menu_bahan_ajar_siswa/bahan_ajar/bahan_ajar_screen.dart';

class Materi extends StatefulWidget {
  @override
  _Materi createState() => _Materi();
}

class _Materi extends State<Materi> {
  var isLoading = false;
  var responseJson, result;
  var code;
  late bool status;
  var materi = [],
      tugasLewatDeadLine = [],
      tugasBelumDeadLine = [],
      quizLewatDeatLine = [],
      quizBelumDeatLine = [],
      kodeKelas = '-';

  var valueTugas = 'Sudah Deadline';
  var valueQuiz = 'Sudah Deadline';

  var data = jsonDecode(dataUserLogin);
  var dataTahunAjaran = jsonDecode(tahunAjaranPref);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getData(10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.5),
                highlightColor: mGreyColor,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        dummyListViewCell(),
                        dummyListViewCell(),
                        dummyListViewCell(),
                      ],
                    ))),
          )
        : Column(
            children: [
              materi.length > 0
                  ? Column(
                      children: [
                        Padding(
                            padding:
                                EdgeInsets.only(left: 16, top: 10, bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: "Materi Baru",
                                      style: mTitleStyle,
                                      children: []),
                                ),
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.only(left: 16, right: 16),
                            // padding: EdgeInsets.all(10),
                            height: 110,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ListView.separated(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: materi == null ? 0 : materi.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: 5,
                                    );
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return buildTaskItem(
                                        'Materi Baru',
                                        '${materi[index]['judul']}',
                                        '${materi[index]['mapel']}',
                                        Color(int.parse(
                                            materi[index]['colorCode'])),
                                        '', materi[index], 'Materi');
                                  }),
                            )),
                      ],
                    )
                  : Container(),
              Padding(
                  padding: EdgeInsets.only(left: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: "Tugas", style: mTitleStyle, children: []),
                      ),
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 4),
                    width: 150,
                    child: ButtonTabs(
                        text: "Sudah Deadline",
                        color: valueTugas == "Sudah Deadline"
                            ? kPrimaryColor
                            : mGreyColor,
                        textColor: valueTugas == "Sudah Deadline"
                            ? Colors.white
                            : Colors.black,
                        press: () {
                          setState(() {
                            valueTugas = "Sudah Deadline";
                          });
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 16),
                    width: 150,
                    child: ButtonTabs(
                        text: "Belum Deadline",
                        color: valueTugas != "Belum Deadline"
                            ? mGreyColor
                            : kPrimaryColor,
                        textColor: valueTugas != "Belum Deadline"
                            ? Colors.black
                            : Colors.white,
                        press: () {
                          setState(() {
                            valueTugas = "Belum Deadline";
                          });
                        }),
                  )
                ],
              ),
              valueTugas == "Sudah Deadline"
                  ? tugasLewatDeadLine.length > 0
                      ? Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                    left: 16, right: 16, top: 10),
                                // padding: EdgeInsets.all(10),
                                height: 110,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ListView.separated(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: tugasLewatDeadLine == null
                                          ? 0
                                          : tugasLewatDeadLine.length,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          height: 5,
                                        );
                                      },
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return buildTaskItem(
                                            '${tugasLewatDeadLine[index]['mapel']}',
                                            '${tugasLewatDeadLine[index]['nama_tugas']}',
                                            tugasLewatDeadLine[index]
                                                        ['statusPengerjaan'] !=
                                                    false
                                                ? tugasLewatDeadLine[index]
                                                        ['statusPengerjaan']
                                                    ['statusPengerjaan']
                                                : 'Belum Dikerjakan',
                                            Color(int.parse(
                                                tugasLewatDeadLine[index]
                                                    ['colorCode'])),
                                            '${tugasLewatDeadLine[index]['tenggat']}',
                                            tugasLewatDeadLine[index], 'Tugas');
                                      }),
                                )),
                          ],
                        )
                      : Container()
                  : tugasBelumDeadLine.length > 0
                  ? Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(
                          left: 16, right: 16, top: 10),
                      // padding: EdgeInsets.all(10),
                      height: 110,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ListView.separated(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: tugasBelumDeadLine == null
                                ? 0
                                : tugasBelumDeadLine.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 5,
                              );
                            },
                            itemBuilder:
                                (BuildContext context, int index) {
                              return buildTaskItem(
                                  '${tugasBelumDeadLine[index]['mapel']}',
                                  '${tugasBelumDeadLine[index]['nama_tugas']}',
                                  tugasBelumDeadLine[index]
                                  ['statusPengerjaan'] !=
                                      false
                                      ? tugasBelumDeadLine[index]
                                  ['statusPengerjaan']
                                  ['statusPengerjaan']
                                      : 'Belum Dikerjakan',
                                  Color(int.parse(
                                      tugasBelumDeadLine[index]
                                      ['colorCode'])),
                                  '${tugasBelumDeadLine[index]['tenggat']}',
                                  tugasBelumDeadLine[index], 'Tugas');
                            }),
                      )),
                ],
              ): Container(),
              Padding(
                  padding: EdgeInsets.only(left: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: "Quiz/Ujian", style: mTitleStyle, children: []),
                      ),
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 4),
                    width: 150,
                    child: ButtonTabs(
                        text: "Sudah Deadline",
                        color: valueQuiz == "Sudah Deadline"
                            ? kPrimaryColor
                            : mGreyColor,
                        textColor: valueQuiz == "Sudah Deadline"
                            ? Colors.white
                            : Colors.black,
                        press: () {
                          setState(() {
                            valueQuiz = "Sudah Deadline";
                          });
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 16),
                    width: 150,
                    child: ButtonTabs(
                        text: "Belum Deadline",
                        color: valueQuiz != "Belum Deadline"
                            ? mGreyColor
                            : kPrimaryColor,
                        textColor: valueQuiz != "Belum Deadline"
                            ? Colors.black
                            : Colors.white,
                        press: () {
                          setState(() {
                            valueQuiz = "Belum Deadline";
                          });
                        }),
                  )
                ],
              ),
              valueQuiz == "Sudah Deadline"
                  ? quizLewatDeatLine.length > 0
                  ? Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(
                          left: 16, right: 16, top: 10),
                      // padding: EdgeInsets.all(10),
                      height: 110,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ListView.separated(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: quizLewatDeatLine == null
                                ? 0
                                : quizLewatDeatLine.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 5,
                              );
                            },
                            itemBuilder:
                                (BuildContext context, int index) {
                              return buildTaskItem(
                                  '${quizLewatDeatLine[index]['mapel']}',
                                  '${quizLewatDeatLine[index]['nama_tugas']}',
                                  quizLewatDeatLine[index]
                                  ['statusPengerjaan'] !=
                                      false
                                      ? quizLewatDeatLine[index]
                                  ['statusPengerjaan']
                                  ['statusPengerjaan']
                                      : 'Belum Dikerjakan',
                                  Color(int.parse(
                                      quizLewatDeatLine[index]
                                      ['colorCode'])),
                                  '${quizLewatDeatLine[index]['tenggat']}',
                                  quizLewatDeatLine[index], 'Quiz');
                            }),
                      )),
                ],
              )
                  : Container()
                  : quizBelumDeatLine.length > 0
                  ? Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(
                          left: 16, right: 16, top: 10),
                      // padding: EdgeInsets.all(10),
                      height: 110,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ListView.separated(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: quizBelumDeatLine == null
                                ? 0
                                : quizBelumDeatLine.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 5,
                              );
                            },
                            itemBuilder:
                                (BuildContext context, int index) {
                              return buildTaskItem(
                                  '${quizBelumDeatLine[index]['mapel']}',
                                  '${quizBelumDeatLine[index]['nama_tugas']}',
                                  quizBelumDeatLine[index]
                                  ['statusPengerjaan'] !=
                                      false
                                      ? quizBelumDeatLine[index]
                                  ['statusPengerjaan']
                                  ['statusPengerjaan']
                                      : 'Belum Dikerjakan',
                                  Color(int.parse(
                                      quizBelumDeatLine[index]
                                      ['colorCode'])),
                                  '${quizBelumDeatLine[index]['tenggat']}',
                                  quizBelumDeatLine[index], 'Quiz');
                            }),
                      )),
                ],
              ): Container(),
            ],
          );
  }

  Widget buildTaskItem(
      String mapel, String judul, String courseTitle, Color color, tenggat, dataIndex, apaIni) {
    return GestureDetector(
      onTap: () {
        if(apaIni == 'Materi') {

          var kirim = {
            "Nip" : dataIndex['nip'],
            "idMapel" : dataIndex['mapel_id'],
            "idkelompokkls" : dataIndex['id_kelompok_kelas'],
            "Namamapel" : dataIndex['mapel'],
            "kode_kelompok" : kodeKelas
          };
          Navigator.pushNamed(
              context, BahanMengajarSiswa.routeName,
              arguments: kirim);
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(12),
        height: 140,
        width: 140,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 250,
              child: Text(
                '$mapel',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 250,
              child: Text(
                judul,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Spacer(),
            Text(
              "$tenggat",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
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
                  "$courseTitle",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget dummyListViewCell() {
    return Container(
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(12),
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: mGreyColor,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Future<String> getData(limit) async {
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
          "${getDashBoarLmsSiswa}/${data['username']}/${dataTahunAjaran['tahunakademik']}/${dataTahunAjaran['semester']}?limit=$limit",
          headers: headers);
      responseJson = json.decode(response.body);

      setState(() {
        isLoading = false;
        status = responseJson['status'];
        code = responseJson['code'];
        if (status == true && code == 200) {
          result = responseJson['result'];
          kodeKelas = result['kodeKelas'];
          materi = result['materi'];
          tugasLewatDeadLine = result['tugas']['lewatDeadline'];
          tugasBelumDeadLine = result['tugas']['belumLewatDeadline'];
          quizLewatDeatLine = result['quiz']['lewatDeadline'];
          quizBelumDeatLine = result['quiz']['belumLewatDeadline'];
        } else if (status == false && code == 403) {
          // AwesomeDialog(
          //     context: context,
          //     dialogType: DialogType.ERROR,
          //     animType: AnimType.RIGHSLIDE,
          //     headerAnimationLoop: true,
          //     title: 'Peringatan',
          //     desc: responseJson['message'],
          //     btnOkOnPress: () {},
          //     btnOkIcon: Icons.cancel,
          //     onDissmissCallback: (type) async {},
          //     btnOkColor: kColorRedSlow)
          //     .show();
          // buildTaskItem('Materi','', '', Color(int.parse(materi[index]['colorCode'])));
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
                        context, HomeSiswa.routeName, (r) => false);
                  },
                  btnOkColor: kColorRedSlow)
              .show();
        });
      }
    }

    return 'success';
  }
}
