import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_apps/screens/features/guru/home_guru.dart';
import 'package:school_apps/server/api.dart';
import 'package:school_apps/helper/utils_apps.dart';

import '../../../../../../constants.dart';
import '../../../../../../main.dart';

class HotelListData {
  HotelListData({
    this.thumbnail = '',
    this.title = '',
    this.subtitle = "",
    this.link = "",
  });

  String thumbnail;
  String title;
  String subtitle;
  String link;

  static List<HotelListData> hotelList = <HotelListData>[
    HotelListData(
      thumbnail: 'assets/tutorial/1.png',
      title: 'A.1 Cara Melakukan Presensi Di Akun Guru',
      subtitle: 'Bab 1 - Bag 1',
      link:
          'https://www.youtube.com/watch?v=12uq606VOKE&list=PLw-TFqGsAV_IvtfOgWMfoW63anN_tZFmn',
    ),
    HotelListData(
      thumbnail: 'assets/tutorial/2.png',
      title: 'A.2 Cara Lihat Rekap Presensi',
      subtitle: 'Bab 1 - Bag 2',
      link:
          'https://www.youtube.com/watch?v=Ir17_3i4wd4&list=PLw-TFqGsAV_IvtfOgWMfoW63anN_tZFmn&index=2',
    ),
    HotelListData(
        thumbnail: 'assets/tutorial/3.png',
        title: 'B.1 Cara Menambah Materi Melalui Bank Materi',
        subtitle: 'Bab 2 - Bag 1',
        link:
            'https://www.youtube.com/watch?v=rSZBsRY0PgA&list=PLw-TFqGsAV_LxMd-dETM4yLAuGQZjuYh8'),
    HotelListData(
        thumbnail: 'assets/tutorial/4.png',
        title: 'B.2 Cara Menambah Tugas Melalui Bank Soal Tugas',
        subtitle: 'Bab 2 - Bag 2',
        link:
            'https://www.youtube.com/watch?v=YUUU_rJXuLU&list=PLw-TFqGsAV_LxMd-dETM4yLAuGQZjuYh8&index=2'),
    HotelListData(
        thumbnail: 'assets/tutorial/5.png',
        title: 'B.3 Cara Koreksi Dan Nilai Tugas',
        subtitle: 'Bab 2 - Bag 3',
        link:
            'https://www.youtube.com/watch?v=Acj-t9yhHuQ&list=PLw-TFqGsAV_LxMd-dETM4yLAuGQZjuYh8&index=3'),
    HotelListData(
        thumbnail: 'assets/tutorial/6.png',
        title: 'B.4 Cara Melihat Dan Edit Tugas',
        subtitle: 'Bab 2 - Bag 4',
        link:
            'https://www.youtube.com/watch?v=ldfjNCuCGx8&list=PLw-TFqGsAV_LxMd-dETM4yLAuGQZjuYh8&index=4'),
    HotelListData(
        thumbnail: 'assets/tutorial/7.png',
        title: 'C.1 Cara Input Bobot Nilai Per Mata Pelajaran',
        subtitle: 'Bab 3 - Bag 1',
        link:
            'https://www.youtube.com/watch?v=TBq4_wkDJMc&list=PLw-TFqGsAV_Kwh07TbES1gxwnxNaPYKYn'),
    HotelListData(
        thumbnail: 'assets/tutorial/8.png',
        title: 'C.2 Cara Input Nilai Manual Dan Keterangan Di Raport',
        subtitle: 'Bab 3 - Bag 2',
        link:
            'https://www.youtube.com/watch?v=CL8GIP9p3Hk&list=PLw-TFqGsAV_Kwh07TbES1gxwnxNaPYKYn&index=2'),
    HotelListData(
        thumbnail: 'assets/tutorial/9.png',
        title: 'C.3 Cara Lihat Nilai Di Akun Guru',
        subtitle: 'Bab 3 - Bag 3',
        link:
            'https://www.youtube.com/watch?v=4AEW5aBryCw&list=PLw-TFqGsAV_Kwh07TbES1gxwnxNaPYKYn&index=3'),
    HotelListData(
        thumbnail: 'assets/tutorial/10.png',
        title: 'D.1 Cara Membuat Quiz/ Ujian Melalu Bank Quiz/ Ujian',
        subtitle: 'Bab 4 - Bag 1',
        link:
            'https://www.youtube.com/watch?v=hDERlpp-yKo&list=PLw-TFqGsAV_JVqyNrM_Tva7-wWwXptm_j'),
    HotelListData(
        thumbnail: 'assets/tutorial/11.png',
        title: 'D.2 Cara Koreksi Quiz/ Ujian Online',
        subtitle: 'Bab 4 - Bag 2',
        link:
            'https://www.youtube.com/watch?v=kFYtZR3_zCM&list=PLw-TFqGsAV_JVqyNrM_Tva7-wWwXptm_j&index=2'),
    HotelListData(
        thumbnail: 'assets/tutorial/12.png',
        title: 'D.3 Cara Melihat Dan Edit Quiz/ Ujian Online',
        subtitle: 'Bab 4 - Bag 3',
        link:
            'https://www.youtube.com/watch?v=mi_16awG1BE&list=PLw-TFqGsAV_JVqyNrM_Tva7-wWwXptm_j&index=3'),
    HotelListData(
        thumbnail: 'assets/tutorial/13.png',
        title: 'E.1 Cara Melihat Rekap Presensi Kelas Yang Dipegang',
        subtitle: 'Bab 5 - Bag 1',
        link:
            'https://www.youtube.com/watch?v=V7QCI1i10SU&list=PLw-TFqGsAV_KxTgs_9EvCx2RjlIvlZECm'),
    HotelListData(
        thumbnail: 'assets/tutorial/14.png',
        title: 'E.2 Cara Melihat Rekap Nilai Yang Dipegang',
        subtitle: 'Bab 5 - Bag 2',
        link:
            'https://www.youtube.com/watch?v=wGv5g8mi15Q&list=PLw-TFqGsAV_KxTgs_9EvCx2RjlIvlZECm&index=2'),
    HotelListData(
        thumbnail: 'assets/tutorial/15.png',
        title: 'Cara Edit Biodata Guru',
        subtitle: 'Profil',
        link:
            'https://www.youtube.com/watch?v=34Lyxjjn4To&list=PLw-TFqGsAV_KEmdiO6xyXtyU45qBaEFEI'),
    HotelListData(
        thumbnail: 'assets/tutorial/16.jpeg',
        title: 'Cara Ganti Kata Sandi',
        subtitle: 'Profil',
        link:
            'https://www.youtube.com/watch?v=e6ewkFFFIfQ&list=PLw-TFqGsAV_KEmdiO6xyXtyU45qBaEFEI&index=3'),
  ];
}

// class VideoListData extends StatefulWidget {
//   const VideoListData({Key? key}) : super(key: key);

//   @override
//   _VideoListDataState createState() => _VideoListDataState();
// }

// class _VideoListDataState extends State<VideoListData> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// Codec<String, String> stringToBase64 = utf8.fuse(base64);
// bool status = false;
// int code = 0;
// var responseJson;
// var dataUser = {};
// var data = jsonDecode(dataUserLogin);

// class GetVideoTutorial {
//   static Future updateProfile(dataProfile, BuildContext context) async {
//     utilsApps.showDialog(context);
//     Map<String, String> headers = {
//       'Content-Type': 'application/json;charset=UTF-8',
//       'Charset': 'utf-8',
//       'x-access-token': data['access_token'],
//       'username': data['username']
//     };

//     try {
//       final response = await http.put('${getVideo}',
//           headers: headers, body: jsonEncode(dataProfile));
//       responseJson = json.decode(response.body);
//       status = responseJson['status'];
//       code = responseJson['code'];
//       if (status == true && code == 200) {
//         // Navigator.pushNamed(context, AbsenKelasScreen.routeName,
//         //     arguments: dataAbsenGuru);
//         Future.delayed(Duration(seconds: 1)).then((value) {
//           utilsApps.hideDialog(context);
//           AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.SUCCES,
//                   animType: AnimType.RIGHSLIDE,
//                   headerAnimationLoop: true,
//                   title: 'Peringatan',
//                   desc: responseJson['message'],
//                   btnOkOnPress: () {
//                     Navigator.pushNamedAndRemoveUntil(
//                         context, HomeGuru.routeName, (r) => false);
//                   },
//                   btnOkIcon: Icons.check,
//                   btnOkColor: kColorTealToSlow)
//               .show();
//         });
//       } else {
//         Future.delayed(Duration(seconds: 1)).then((value) {
//           utilsApps.hideDialog(context);
//           AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.WARNING,
//                   animType: AnimType.RIGHSLIDE,
//                   headerAnimationLoop: true,
//                   title: 'Peringatan',
//                   desc: responseJson['message'],
//                   btnOkOnPress: () {},
//                   btnOkIcon: Icons.cancel,
//                   btnOkColor: kColorYellow)
//               .show();
//           // utilsApps.dengerSnack(context, responseJson['message']);
//         });
//       }
//       // print(dataUser);
//     } catch (e) {
//       Future.delayed(Duration(seconds: 1)).then((value) {
//         utilsApps.hideDialog(context);
//         AwesomeDialog(
//                 context: context,
//                 dialogType: DialogType.ERROR,
//                 animType: AnimType.RIGHSLIDE,
//                 headerAnimationLoop: true,
//                 title: 'Peringatan',
//                 desc: "Terjadi kesalahan pada server",
//                 btnOkOnPress: () {},
//                 btnOkIcon: Icons.cancel,
//                 btnOkColor: kColorRedSlow)
//             .show();
//       });
//     }
//   }
// }
