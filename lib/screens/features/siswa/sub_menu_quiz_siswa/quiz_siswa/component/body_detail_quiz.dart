import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school_apps/server/api.dart';

import '../../../../../../constants.dart';
import '../../../../../../main.dart';
import '../detail_quiz_screens.dart';
import 'components_detail_quiz.dart';
import 'package:http/http.dart' as http;

class BodyDetailQuizSiswa extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<BodyDetailQuizSiswa> {

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
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text(
                'Nama Quiz : ${DetailQuizSiswa.dataTugasFromDetailTugas['nama_tugas']}',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
              Text(
                'Keterangan Quiz : ${DetailQuizSiswa.dataTugasFromDetailTugas['keterangan']}',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: kPrimaryColor),
              ),
              isLoading ? const Text("-") :
              Text(
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
          height: 12,
        ),
        ComponentDetailQuiz()
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
          "$nilaiFinal/${data['username']}/${DetailQuizSiswa.dataTugasFromDetailTugas['id']}",
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
          if(dataNilaiFinal['nilai'] == 'null') {
            dataNilaiFinal['nilai'] = '0';
          }
        } else if (status == false && code == 403) {
          // AwesomeDialog(
          //     context: context,
          //     dialogType: DialogType.WARNING,
          //     animType: AnimType.RIGHSLIDE,
          //     headerAnimationLoop: true,
          //     title: 'Peringatan',
          //     desc:
          //     '${responseJson['message']}, Klik Ok untuk membuat bahan mengajar',
          //     btnOkOnPress: () {
          //       // Navigator.pushNamed(context, InputBahanAjar.routeName,
          //       //     arguments: BahanMengajar.dataMapelPerIndex);
          //     },
          //     btnOkIcon: Icons.check,
          //     onDissmissCallback: (type) {},
          //     btnOkColor: kColorYellow)
          //     .show();
        } else {
          // AwesomeDialog(
          //     context: context,
          //     dialogType: DialogType.ERROR,
          //     animType: AnimType.RIGHSLIDE,
          //     headerAnimationLoop: true,
          //     title: 'Peringatan',
          //     desc: "Sesi anda telah habis, mohon login kembali",
          //     btnOkOnPress: () {},
          //     btnOkIcon: Icons.cancel,
          //     onDissmissCallback: (type) async {
          //       //SignInScreen
          //       Navigator.pushNamedAndRemoveUntil(
          //           context, SignInScreen.routeName, (r) => false);
          //       final pref = await SharedPreferences.getInstance();
          //       await pref.clear();
          //     },
          //     btnOkColor: kColorRedSlow)
          //     .show();
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
        //           context, HomeSiswa.routeName, (r) => false);
        //     },
        //     btnOkColor: kColorRedSlow)
        //     .show();
      });
    }

    return 'success';
  }
}
