import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_apps/screens/features/wali_murid/sub_menu_tugas/tugas/components/component_detail_tugas.dart';
import 'package:school_apps/screens/features/wali_murid/sub_menu_tugas/tugas/detail_tugas_screen.dart';
import 'package:school_apps/screens/features/wali_murid/sub_menu_tugas/tugas/playvideoyoutube.dart';
import 'package:school_apps/server/api.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../constants.dart';
import '../../../../../../main.dart';
import 'package:http/http.dart' as http;

class WaliMuridBodyDetailTugasSiswa extends StatefulWidget {
  const WaliMuridBodyDetailTugasSiswa({Key? key}) : super(key: key);

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<WaliMuridBodyDetailTugasSiswa> {
  List<dynamic> idDetailTugas = [];
  var data = jsonDecode(dataUserLogin);
  var isLoading = false;
  var responseJson, dataNilaiFinal;
  var status, code;

  var dataTahunAjaran = jsonDecode(tahunAjaranPref);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: <Widget>[
        const SizedBox(
          height: 12,
        ),
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nama Tugas : ${WaliMuridDetailTugasSiswa.dataTugasFromDetailTugas['nama_tugas']}",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
              Text(
                "Keterangan Tugas : ${WaliMuridDetailTugasSiswa.dataTugasFromDetailTugas['keterangan'] ?? 'Tidak Ada Keterangan'}",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
              WaliMuridDetailTugasSiswa.dataTugasFromDetailTugas['link_youtube'] == null
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, WaliMuridPlayVideoDetailTugasSiswa.routeName,
                            arguments:
                                WaliMuridDetailTugasSiswa.dataTugasFromDetailTugas);
                      },
                      child: const Chip(
                        backgroundColor: kColorBlue,
                        label: Text(
                          "Lihat video Youtube",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
              WaliMuridDetailTugasSiswa.dataTugasFromDetailTugas['link_sumberlain'] ==
                      null
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        _launchInBrowser(
                            '${WaliMuridDetailTugasSiswa.dataTugasFromDetailTugas['link_sumberlain']}');
                      },
                      child: const Chip(
                        backgroundColor: kColorBlue,
                        label: Text(
                          "Lihat Dari Sumber Lain",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
              isLoading
                  ? const Text("-")
                  : Text(
                      'Total Nilai : ${dataNilaiFinal['nilai']}',
                      // "ad",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: kPrimaryColor),
                    ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Tipe Soal :",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const WaliMuridComponentDetailTugas()
        // KategoriNilai()
      ],
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
          "$nilaiFinal/${data['nisn']}/${WaliMuridDetailTugasSiswa.dataTugasFromDetailTugas['id']}",
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
          dataNilaiFinal = responseJson['result'];
          print(dataNilaiFinal);
          if (dataNilaiFinal['nilai'] == 'null' ||
              dataNilaiFinal['nilai'] == null) {
            dataNilaiFinal['nilai'] = '0';
          }
        } else if (status == false && code == 403) {
        } else {}
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }

    return 'success';
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
