import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_apps/components/PilihanGandaHtml.dart';
import 'package:school_apps/components/pilihanGanda.dart';
import 'package:school_apps/screens/features/siswa/home_siswa.dart';
import 'package:school_apps/screens/features/siswa/sub_menu_tugas_siswa/soal_tugas/response/responsejawaban.dart';
import 'package:school_apps/screens/login/login_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../../constants.dart';
import '../../../../../../main.dart';
import 'package:school_apps/server/api.dart';
import 'package:http/http.dart' as http;

import '../soal_screens.dart';

class komponentSoal extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<komponentSoal> {
  var isLoading = false;
  var responseJson, dataSoal;
  var status, code;

  var data = jsonDecode(dataUserLogin);
  var dataTahunAjaran = jsonDecode(tahunAjaranPref);
  Future<void>? _launched;

  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? conform_password;
  final List<String?> errors = [];
  String type = '';
  TextEditingController jawabanText = TextEditingController();
  late List<TextEditingController> jawabArray;

  bool isLoadingPath = false;
  bool isMultiPick = false;
  FileType? fileType;
  String? fileName;
  String? path;
  Map<String, String>? paths;
  List<String>? extensions;
  String? name;
  String? filePath;
  String? files;

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    jawabArray = List.generate(
        dataSoal == null ? 0 : dataSoal.length, (i) => TextEditingController());
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
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, __) => (dummyListViewCell()),
                itemCount: 10,
              ),
            ),
          )
        : ListView(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            children: [
              ListView.separated(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: dataSoal == null ? 0 : dataSoal.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    print(dataSoal[index]);
                    jawabArray.add(new TextEditingController());
                    int no = index + 1;
                    return _listMataPelajaran(
                        '$no. ${dataSoal[index]['soal']}',
                        '${dataSoal[index]['jawaban']}',
                        '${dataSoal[index]['file']}',
                        '${dataSoal[index]['pilihan_a']}',
                        '${dataSoal[index]['pilihan_b']}',
                        '${dataSoal[index]['pilihan_c']}',
                        '${dataSoal[index]['pilihan_d']}',
                        '${dataSoal[index]['pilihan_e']}',
                        '${dataSoal[index]['jawaban_benar']}',
                        index,
                        '${dataSoal[index]['jawaban_file']}',
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            dataSoal[index]['jawaban'] =
                                jawabArray[index].text;
                            var jawaban = {
                              "id_soal": dataSoal[index]['id'],
                              "idDetailTugas":
                              '${dataSoal[index]['idDetailTugas']}',
                              "nisn": dataSoal[index]['nisn'],
                              "jawaban": dataSoal[index]['jawaban']
                            };
                            JawabanResponse.inputJawabanRes(jawaban, context);
                          });
                        },
                        child: const Chip(
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          avatar: Icon(
                            FontAwesomeIcons.penAlt,
                            color: Colors.white,
                            size: 20,
                          ),
                          backgroundColor: kPrimaryColor,
                          label: Text(
                            "Jawab",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          var urlFake = '${baseUrlTugas}${dataSoal[index]['file']}';
                          var urlReal = urlFake.replaceAll(" ", "%20");
                          _launched = _launchInBrowser(
                              urlReal);
                          // _launched = _launchInBrowser(
                          //     '${baseUrlTugas}${dataSoal[index]['file']}');
                          // _launched = _launchInBrowser('https://www.youtube.com/watch?v=1YE4CIzqG_Y');
                        },
                        child: const Chip(
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          avatar: Icon(
                            FontAwesomeIcons.fileDownload,
                            color: Colors.white,
                            size: 20,
                          ),
                          backgroundColor: kColorTealSlow,
                          label: Text(
                            "Lihat File",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if(name == '' || name == null){
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.WARNING,
                                animType: AnimType.RIGHSLIDE,
                                headerAnimationLoop: true,
                                title: 'Peringatan',
                                desc: 'File belum di pilih',
                                btnOkOnPress: () {
                                  // Navigator.pushNamed(context, DetailTugas.routeName,
                                  //     arguments: {"id": InputSoalEssay.data['idTugas']});
                                },
                                btnOkIcon: Icons.check,
                                btnOkColor: kColorYellow)
                                .show();
                          }else {
                            setState(() {
                              JawabanResponse.inputJawabanFileRes(
                                  '${dataSoal[index]['id']}',
                                  '${dataSoal[index]['idDetailTugas']}',
                                  dataSoal[index]['nisn'],
                                  filePath,
                                  context);
                            });
                          }
                        },
                        child: const Chip(
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          avatar: Icon(
                            FontAwesomeIcons.paperPlane,
                            color: Colors.white,
                            size: 20,
                          ),
                          backgroundColor: kPrimaryColor,
                          label: Text(
                            "Kirim Jawaban",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            var urlFake = '${baseUrlJawaban}${dataSoal[index]['jawaban_file']}';
                            var urlReal = urlFake.replaceAll(" ", "%20");
                            _launched = _launchInBrowser(
                                urlReal);
                          });
                        },
                        child: const Chip(
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          avatar: Icon(
                            FontAwesomeIcons.eye,
                            color: Colors.white,
                            size: 20,
                          ),
                          backgroundColor: kPrimaryColor,
                          label: Text(
                            "Lihat Jawaban",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            file();
                          });
                        },
                        child: const Chip(
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          avatar: Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                            size: 20,
                          ),
                          backgroundColor: kColorBlue,
                          label: Text(
                            "Pilih File",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 10)
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

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  _listMataPelajaran(
      String soal,
      jawaban,
      files,
      jawabanA,
      jawabanB,
      jawabanC,
      jawabanD,
      jawabanE,
      jawabanBenar,
      index,
      jawabanFile,
      GestureDetector jawab,
      GestureDetector file,
      GestureDetector kirimFile,
      GestureDetector lihatFile,
      GestureDetector pilihFile) {
    var gambar = files.substring(files.length - 3);

    print(jawabanFile);
    if (SoalQuizSiswa.dataTugas['type'] == 'Essay') {
      // jawabArray[index].text = dataSoal[index]['jawaban'];
      if (files != 'null') {
        return Row(
          children: [
            Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(soal,
                      //     maxLines: 3,
                      //     overflow: TextOverflow.ellipsis,
                      //     style: (const TextStyle(fontWeight: FontWeight.bold))),
                      Html(data: soal, customRender: {
                        "iframe": (RenderContext context, Widget child) {
                          var attrs = context.tree.element?.attributes;
                          if (attrs != null) {
                            double? width = double.tryParse(attrs['width'] ?? "");
                            double? height = double.tryParse(attrs['height'] ?? "");
                            String src = attrs['src'] ?? "";
                            String url = "https:"+src;
                            // String? url = "https"+attrs['src'];
                            print(url);
                            return Container(
                              width: width ?? (height ?? 150) * 2,
                              height: height ?? (width ?? 300) / 2,
                              child: WebView(
                                initialUrl: url,
                                javascriptMode: JavascriptMode.unrestricted,
                                onWebViewCreated: (WebViewController webViewController) {
                                  _controller.complete(webViewController);
                                },
                                //no need for scrolling gesture recognizers on embedded youtube, so set gestureRecognizers null
                                //on other iframe content scrolling might be necessary, so use VerticalDragGestureRecognizer
                                // gestureRecognizers: attrs['src'] != null &&
                                //         attrs['src']!.contains("youtube.com/embed")
                                //     ? null
                                //     : [Factory(() => VerticalDragGestureRecognizer())]
                                //         .toSet(),
                                // navigationDelegate: (NavigationRequest request) async {
                                //   //no need to load any url besides the embedded youtube url when displaying embedded youtube, so prevent url loading
                                //   //on other iframe content allow all url loading
                                //   if (attrs['src'] != null &&
                                //       attrs['src']!.contains("youtube.com/embed")) {
                                //     if (!request.url.contains("youtube.com/embed")) {
                                //       return NavigationDecision.prevent;
                                //     } else {
                                //       return NavigationDecision.navigate;
                                //     }
                                //   } else {
                                //     return NavigationDecision.navigate;
                                //   }
                                // },
                              ),
                            );
                          } else {
                            return Container(height: 0);
                          }
                        }
                      }),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(
                            "$baseUrlTugas$files",
                            errorBuilder: (BuildContext context, Object exception,
                                StackTrace? stackTrace) {
                              return Image.asset(
                                'assets/images/404-error.png',
                                width: MediaQuery.of(context).size.width - 40,
                                height: 170,
                              );
                            },
                            width: MediaQuery.of(context).size.width - 40,
                            height: 170,
                            fit: BoxFit.fill,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text("Jawaban :\n$jawaban",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: (const TextStyle(fontWeight: FontWeight.bold))),
                      const SizedBox(height: 10),
                      Container(
                        child: TextField(
                          textAlign: TextAlign.start,
                          controller: jawabArray[index],
                          autofocus: false,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          // onChanged: (change) {
                          //   setState(() {
                          //     dataSoal[index]['jawaban'] =
                          //         change;
                          //     var jawaban = {
                          //       "id_soal": dataSoal[index]['id'],
                          //       "idDetailTugas":
                          //       '${dataSoal[index]['idDetailTugas']}',
                          //       "nisn": dataSoal[index]['nisn'],
                          //       "jawaban": dataSoal[index]['jawaban']
                          //     };
                          //     // JawabanResponse.inputJawabanRes(jawaban, context);
                          //   });
                          // },
                          decoration: const InputDecoration(
                            labelText: "Jawaban Anda *",
                            hintText: "Masukan jawaban disini",
                            prefixIcon: Icon(Icons.task),
                            // If  you are using latest version orf flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                          child: Row(
                            children: [
                              // file,
                              // SizedBox(
                              //   width: 5,
                              // ),
                              jawab
                            ],
                          )),
                      const SizedBox(height: 10),
                    ],
                  ),
                ))
          ],
        );
      } else {
        return Row(
          children: [
            Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(soal,
                      //     maxLines: 3,
                      //     overflow: TextOverflow.ellipsis,
                      //     style: (const TextStyle(fontWeight: FontWeight.bold))),
                      Html(data: soal, customRender: {
                        "iframe": (RenderContext context, Widget child) {
                          var attrs = context.tree.element?.attributes;
                          if (attrs != null) {
                            double? width = double.tryParse(attrs['width'] ?? "");
                            double? height = double.tryParse(attrs['height'] ?? "");
                            String src = attrs['src'] ?? "";
                            String url = "https:"+src;
                            // String? url = "https"+attrs['src'];
                            print(url);
                            return Container(
                              width: width ?? (height ?? 150) * 2,
                              height: height ?? (width ?? 300) / 2,
                              child: WebView(
                                initialUrl: url,
                                javascriptMode: JavascriptMode.unrestricted,
                                onWebViewCreated: (WebViewController webViewController) {
                                  _controller.complete(webViewController);
                                },
                                //no need for scrolling gesture recognizers on embedded youtube, so set gestureRecognizers null
                                //on other iframe content scrolling might be necessary, so use VerticalDragGestureRecognizer
                                // gestureRecognizers: attrs['src'] != null &&
                                //         attrs['src']!.contains("youtube.com/embed")
                                //     ? null
                                //     : [Factory(() => VerticalDragGestureRecognizer())]
                                //         .toSet(),
                                // navigationDelegate: (NavigationRequest request) async {
                                //   //no need to load any url besides the embedded youtube url when displaying embedded youtube, so prevent url loading
                                //   //on other iframe content allow all url loading
                                //   if (attrs['src'] != null &&
                                //       attrs['src']!.contains("youtube.com/embed")) {
                                //     if (!request.url.contains("youtube.com/embed")) {
                                //       return NavigationDecision.prevent;
                                //     } else {
                                //       return NavigationDecision.navigate;
                                //     }
                                //   } else {
                                //     return NavigationDecision.navigate;
                                //   }
                                // },
                              ),
                            );
                          } else {
                            return Container(height: 0);
                          }
                        }
                      }),
                      const SizedBox(height: 10),
                      Text("Jawaban :\n$jawaban",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: (const TextStyle(fontWeight: FontWeight.bold))),
                      const SizedBox(height: 10),
                      TextField(
                        textAlign: TextAlign.start,
                        controller: jawabArray[index],
                        autofocus: false,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        // onChanged: (change) {
                        //   setState(() {
                        //     dataSoal[index]['jawaban'] =
                        //         change;
                        //     var jawaban = {
                        //       "id_soal": dataSoal[index]['id'],
                        //       "idDetailTugas":
                        //       '${dataSoal[index]['idDetailTugas']}',
                        //       "nisn": dataSoal[index]['nisn'],
                        //       "jawaban": dataSoal[index]['jawaban']
                        //     };
                        //     // JawabanResponse.inputJawabanRes(jawaban, context);
                        //   });
                        // },
                        decoration: const InputDecoration(
                          labelText: "Jawaban Anda *",
                          hintText: "Masukan jawaban disini",
                          prefixIcon: Icon(Icons.task),
                          // If  you are using latest version orf flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                          child: Row(
                            children: [
                              // file,
                              // SizedBox(
                              //   width: 5,
                              // ),
                              jawab
                            ],
                          )),
                      const SizedBox(height: 10),
                    ],
                  ),
                ))
          ],
        );
      }
    } else if (SoalQuizSiswa.dataTugas['type'] == 'File') {
      return Row(
        children: [
          Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(soal,
                    //     maxLines: 3,
                    //     overflow: TextOverflow.ellipsis,
                    //     style: (const TextStyle(fontWeight: FontWeight.bold))),
                    Html(data: soal,customRender: {
                      "iframe": (RenderContext context, Widget child) {
                        var attrs = context.tree.element?.attributes;
                        if (attrs != null) {
                          double? width = double.tryParse(attrs['width'] ?? "");
                          double? height = double.tryParse(attrs['height'] ?? "");
                          String src = attrs['src'] ?? "";
                          String url = "https:"+src;
                          // String? url = "https"+attrs['src'];
                          print(url);
                          return Container(
                            width: width ?? (height ?? 150) * 2,
                            height: height ?? (width ?? 300) / 2,
                            child: WebView(
                              initialUrl: url,
                              javascriptMode: JavascriptMode.unrestricted,
                              onWebViewCreated: (WebViewController webViewController) {
                                _controller.complete(webViewController);
                              },
                              //no need for scrolling gesture recognizers on embedded youtube, so set gestureRecognizers null
                              //on other iframe content scrolling might be necessary, so use VerticalDragGestureRecognizer
                              // gestureRecognizers: attrs['src'] != null &&
                              //         attrs['src']!.contains("youtube.com/embed")
                              //     ? null
                              //     : [Factory(() => VerticalDragGestureRecognizer())]
                              //         .toSet(),
                              // navigationDelegate: (NavigationRequest request) async {
                              //   //no need to load any url besides the embedded youtube url when displaying embedded youtube, so prevent url loading
                              //   //on other iframe content allow all url loading
                              //   if (attrs['src'] != null &&
                              //       attrs['src']!.contains("youtube.com/embed")) {
                              //     if (!request.url.contains("youtube.com/embed")) {
                              //       return NavigationDecision.prevent;
                              //     } else {
                              //       return NavigationDecision.navigate;
                              //     }
                              //   } else {
                              //     return NavigationDecision.navigate;
                              //   }
                              // },
                            ),
                          );
                        } else {
                          return Container(height: 0);
                        }
                      }
                    }),
                    const SizedBox(height: 10),
                    Container(
                        child: Row(
                          children: [
                            file,
                            const SizedBox(
                              width: 5,
                            ),
                            pilihFile
                          ],
                        )),
                    const SizedBox(height: 10),
                    Container(
                      child: _files(),
                    ),
                    jawabanFile == '-' ? kirimFile : lihatFile,
                    // kirimFile,
                    // lihatFile,
                    const SizedBox(height: 10),
                  ],
                ),
              ))
        ],
      );
    } else {
      // Pilihan Ganda
      if (files != "null") {
        return Row(
          children: [
            Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(soal,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: (const TextStyle(fontWeight: FontWeight.bold))),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(
                            "$baseUrlTugas$files",
                            errorBuilder: (BuildContext context, Object exception,
                                StackTrace? stackTrace) {
                              return Image.asset(
                                'assets/images/404-error.png',
                                width: MediaQuery.of(context).size.width - 40,
                                height: 170,
                              );
                            },
                            width: MediaQuery.of(context).size.width - 40,
                            height: 170,
                            fit: BoxFit.fill,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text('Pilihan :',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: (TextStyle(fontWeight: FontWeight.bold))),
                      const SizedBox(height: 10),
                      PilihanGandaHtml(
                          color:
                          jawaban == 'A' ? kColorTealToSlow : const Color(0xFFF5F6F9),
                          textColor: jawaban == 'A' ? Colors.white : Colors.grey,
                          pilihan: 'A. ',
                          text: jawabanA,
                          press: () {
                            setState(() {
                              dataSoal[index]['jawaban'] = 'A';
                              int nilaiNya = 0;
                              if (dataSoal[index]['jawaban'] == jawabanBenar) {
                                nilaiNya = 100;
                              } else {
                                nilaiNya = 0;
                              }
                              var jawaban = {
                                "idDetailTugas":
                                '${dataSoal[index]['idDetailTugas']}',
                                "id_soal": dataSoal[index]['id'],
                                "nisn": dataSoal[index]['nisn'],
                                "nilai_per_soal": '$nilaiNya',
                                "jawaban": dataSoal[index]['jawaban']
                              };
                              JawabanResponse.inputJawabanPgRes(jawaban, context);
                            });
                          }),
                      PilihanGandaHtml(
                          color:
                          jawaban == 'B' ? kColorTealToSlow : const Color(0xFFF5F6F9),
                          textColor: jawaban == 'B' ? Colors.white : Colors.grey,
                          pilihan: 'B. ',
                          text: jawabanB,
                          press: () {
                            setState(() {
                              dataSoal[index]['jawaban'] = 'B';
                              int nilaiNya = 0;
                              if (dataSoal[index]['jawaban'] == jawabanBenar) {
                                nilaiNya = 100;
                              } else {
                                nilaiNya = 0;
                              }
                              var jawaban = {
                                "idDetailTugas":
                                '${dataSoal[index]['idDetailTugas']}',
                                "id_soal": dataSoal[index]['id'],
                                "nisn": dataSoal[index]['nisn'],
                                "nilai_per_soal": '$nilaiNya',
                                "jawaban": dataSoal[index]['jawaban']
                              };
                              JawabanResponse.inputJawabanPgRes(jawaban, context);
                            });
                          }),
                      PilihanGandaHtml(
                          color:
                          jawaban == 'C' ? kColorTealToSlow : const Color(0xFFF5F6F9),
                          textColor: jawaban == 'C' ? Colors.white : Colors.grey,
                          pilihan: 'C. ',
                          text: jawabanC,
                          press: () {
                            setState(() {
                              dataSoal[index]['jawaban'] = 'C';
                              int nilaiNya = 0;
                              if (dataSoal[index]['jawaban'] == jawabanBenar) {
                                nilaiNya = 100;
                              } else {
                                nilaiNya = 0;
                              }
                              var jawaban = {
                                "idDetailTugas":
                                '${dataSoal[index]['idDetailTugas']}',
                                "id_soal": dataSoal[index]['id'],
                                "nisn": dataSoal[index]['nisn'],
                                "nilai_per_soal": '$nilaiNya',
                                "jawaban": dataSoal[index]['jawaban']
                              };
                              JawabanResponse.inputJawabanPgRes(jawaban, context);
                            });
                          }),
                      PilihanGandaHtml(
                          color:
                          jawaban == 'D' ? kColorTealToSlow : const Color(0xFFF5F6F9),
                          textColor: jawaban == 'D' ? Colors.white : Colors.grey,
                          pilihan: 'D. ',
                          text: jawabanD,
                          press: () {
                            setState(() {
                              dataSoal[index]['jawaban'] = 'D';
                              int nilaiNya = 0;
                              if (dataSoal[index]['jawaban'] == jawabanBenar) {
                                nilaiNya = 100;
                              } else {
                                nilaiNya = 0;
                              }
                              var jawaban = {
                                "idDetailTugas":
                                '${dataSoal[index]['idDetailTugas']}',
                                "idDetailTugas":
                                '${SoalQuizSiswa.dataTugas['idDetailSoal']}',
                                "id_soal": dataSoal[index]['id'],
                                "nisn": dataSoal[index]['nisn'],
                                "nilai_per_soal": '$nilaiNya',
                                "jawaban": dataSoal[index]['jawaban']
                              };
                              JawabanResponse.inputJawabanPgRes(jawaban, context);
                            });
                          }),
                      PilihanGandaHtml(
                          color:
                          jawaban == 'E' ? kColorTealToSlow : const Color(0xFFF5F6F9),
                          textColor: jawaban == 'E' ? Colors.white : Colors.grey,
                          pilihan: 'E. ',
                          text: jawabanE,
                          press: () {
                            setState(() {
                              dataSoal[index]['jawaban'] = 'E';
                              int nilaiNya = 0;
                              if (dataSoal[index]['jawaban'] == jawabanBenar) {
                                nilaiNya = 100;
                              } else {
                                nilaiNya = 0;
                              }
                              var jawaban = {
                                "idDetailTugas":
                                '${dataSoal[index]['idDetailTugas']}',
                                "id_soal": dataSoal[index]['id'],
                                "nisn": dataSoal[index]['nisn'],
                                "nilai_per_soal": '$nilaiNya',
                                "jawaban": dataSoal[index]['jawaban']
                              };
                              JawabanResponse.inputJawabanPgRes(jawaban, context);
                            });
                          }),
                    ],
                  ),
                ))
          ],
        );
      } else {
        return Row(
          children: [
            Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(soal,
                      //     maxLines: 3,
                      //     overflow: TextOverflow.ellipsis,
                      //     style: (const TextStyle(fontWeight: FontWeight.bold))),
                      Html(data: soal,customRender: {
                        "iframe": (RenderContext context, Widget child) {
                          var attrs = context.tree.element?.attributes;
                          if (attrs != null) {
                            double? width = double.tryParse(attrs['width'] ?? "");
                            double? height = double.tryParse(attrs['height'] ?? "");
                            String src = attrs['src'] ?? "";
                            String url = "https:"+src;
                            // String? url = "https"+attrs['src'];
                            print(url);
                            return Container(
                              width: width ?? (height ?? 150) * 2,
                              height: height ?? (width ?? 300) / 2,
                              child: WebView(
                                initialUrl: url,
                                javascriptMode: JavascriptMode.unrestricted,
                                onWebViewCreated: (WebViewController webViewController) {
                                  _controller.complete(webViewController);
                                },
                                //no need for scrolling gesture recognizers on embedded youtube, so set gestureRecognizers null
                                //on other iframe content scrolling might be necessary, so use VerticalDragGestureRecognizer
                                // gestureRecognizers: attrs['src'] != null &&
                                //         attrs['src']!.contains("youtube.com/embed")
                                //     ? null
                                //     : [Factory(() => VerticalDragGestureRecognizer())]
                                //         .toSet(),
                                // navigationDelegate: (NavigationRequest request) async {
                                //   //no need to load any url besides the embedded youtube url when displaying embedded youtube, so prevent url loading
                                //   //on other iframe content allow all url loading
                                //   if (attrs['src'] != null &&
                                //       attrs['src']!.contains("youtube.com/embed")) {
                                //     if (!request.url.contains("youtube.com/embed")) {
                                //       return NavigationDecision.prevent;
                                //     } else {
                                //       return NavigationDecision.navigate;
                                //     }
                                //   } else {
                                //     return NavigationDecision.navigate;
                                //   }
                                // },
                              ),
                            );
                          } else {
                            return Container(height: 0);
                          }
                        }
                      }),
                      const SizedBox(height: 10),
                      const Text('Pilihan :',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: (const TextStyle(fontWeight: FontWeight.bold))),
                      PilihanGandaHtml(
                          color:
                          jawaban == 'A' ? kColorTealToSlow : const Color(0xFFF5F6F9),
                          textColor: jawaban == 'A' ? Colors.white : Colors.grey,
                          pilihan: 'A. ',
                          text: jawabanA,
                          press: () {
                            setState(() {
                              dataSoal[index]['jawaban'] = 'A';
                              int nilaiNya = 0;
                              if (dataSoal[index]['jawaban'] == jawabanBenar) {
                                nilaiNya = 100;
                              } else {
                                nilaiNya = 0;
                              }
                              print(dataSoal[index]['jawaban'] + jawabanBenar);
                              var jawaban = {
                                "idDetailTugas":
                                '${dataSoal[index]['idDetailTugas']}',
                                "id_soal": dataSoal[index]['id'],
                                "nisn": dataSoal[index]['nisn'],
                                "nilai_per_soal": '$nilaiNya',
                                "jawaban": dataSoal[index]['jawaban']
                              };
                              JawabanResponse.inputJawabanPgRes(jawaban, context);
                            });
                          }),
                      PilihanGandaHtml(
                          color:
                          jawaban == 'B' ? kColorTealToSlow : const Color(0xFFF5F6F9),
                          textColor: jawaban == 'B' ? Colors.white : Colors.grey,
                          pilihan: 'B. ',
                          text: jawabanB,
                          press: () {
                            setState(() {
                              dataSoal[index]['jawaban'] = 'B';
                              int nilaiNya = 0;
                              if (dataSoal[index]['jawaban'] == jawabanBenar) {
                                nilaiNya = 100;
                              } else {
                                nilaiNya = 0;
                              }
                              var jawaban = {
                                "idDetailTugas":
                                '${dataSoal[index]['idDetailTugas']}',
                                "id_soal": dataSoal[index]['id'],
                                "nisn": dataSoal[index]['nisn'],
                                "nilai_per_soal": '$nilaiNya',
                                "jawaban": dataSoal[index]['jawaban']
                              };
                              JawabanResponse.inputJawabanPgRes(jawaban, context);
                            });
                          }),
                      PilihanGandaHtml(
                          color:
                          jawaban == 'C' ? kColorTealToSlow : const Color(0xFFF5F6F9),
                          textColor: jawaban == 'C' ? Colors.white : Colors.grey,
                          pilihan: 'C. ',
                          text: jawabanC,
                          press: () {
                            setState(() {
                              dataSoal[index]['jawaban'] = 'C';
                              int nilaiNya = 0;
                              if (dataSoal[index]['jawaban'] == jawabanBenar) {
                                nilaiNya = 100;
                              } else {
                                nilaiNya = 0;
                              }
                              var jawaban = {
                                "idDetailTugas":
                                '${dataSoal[index]['idDetailTugas']}',
                                "id_soal": dataSoal[index]['id'],
                                "nisn": dataSoal[index]['nisn'],
                                "nilai_per_soal": '$nilaiNya',
                                "jawaban": dataSoal[index]['jawaban']
                              };
                              JawabanResponse.inputJawabanPgRes(jawaban, context);
                            });
                          }),
                      PilihanGandaHtml(
                          color:
                          jawaban == 'D' ? kColorTealToSlow : const Color(0xFFF5F6F9),
                          textColor: jawaban == 'D' ? Colors.white : Colors.grey,
                          pilihan: 'D. ',
                          text: jawabanD,
                          press: () {
                            setState(() {
                              dataSoal[index]['jawaban'] = 'D';
                              int nilaiNya = 0;
                              if (dataSoal[index]['jawaban'] == jawabanBenar) {
                                nilaiNya = 100;
                              } else {
                                nilaiNya = 0;
                              }
                              var jawaban = {
                                "idDetailTugas":
                                '${dataSoal[index]['idDetailTugas']}',
                                "id_soal": dataSoal[index]['id'],
                                "nisn": dataSoal[index]['nisn'],
                                "nilai_per_soal": '$nilaiNya',
                                "jawaban": dataSoal[index]['jawaban']
                              };
                              JawabanResponse.inputJawabanPgRes(jawaban, context);
                            });
                          }),
                      PilihanGandaHtml(
                          color:
                          jawaban == 'E' ? kColorTealToSlow : const Color(0xFFF5F6F9),
                          textColor: jawaban == 'E' ? Colors.white : Colors.grey,
                          pilihan: 'E. ',
                          text: jawabanE,
                          press: () {
                            setState(() {
                              dataSoal[index]['jawaban'] = 'E';
                              int nilaiNya = 0;
                              if (dataSoal[index]['jawaban'] == jawabanBenar) {
                                nilaiNya = 100;
                              } else {
                                nilaiNya = 0;
                              }
                              var jawaban = {
                                "idDetailTugas":
                                '${dataSoal[index]['idDetailTugas']}',
                                "id_soal": dataSoal[index]['id'],
                                "nisn": dataSoal[index]['nisn'],
                                "nilai_per_soal": '$nilaiNya',
                                "jawaban": dataSoal[index]['jawaban']
                              };
                              JawabanResponse.inputJawabanPgRes(jawaban, context);
                            });
                          }),
                      const SizedBox(height: 10),
                    ],
                  ),
                ))
          ],
        );
      }
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
          "${getSoalDanJawabanByNisn}${data['username']}/${SoalQuizSiswa.dataTugas['idDetailSoal']}",
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
          dataSoal = responseJson['result'];
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


  void file () async{
    setState(() => isLoadingPath = true);
    try {
      if (isMultiPick) {
        path = null;
        paths = await FilePicker.getMultiFilePath(
            type: fileType ?? FileType.any,
            allowedExtensions: extensions);
      } else {
        path = await FilePicker.getFilePath(
            type: fileType ?? FileType.any,
            allowedExtensions: extensions);
        paths = null;
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      isLoadingPath = false;
      fileName = path != null
          ? path!.split('/').last
          : paths != null
          ? paths!.keys.toString()
          : '...';
    });
  }

  _files() {
    return Builder(
      builder: (BuildContext context) => isLoadingPath
          ? new Container()
          : path != null || paths != null
          ? Container(
        padding: const EdgeInsets.only(bottom: 0.0),
        height: 60,
        child: Scrollbar(
            child: ListView.separated(
              itemCount:
              paths != null && paths!.isNotEmpty ? paths!.length : 1,
              itemBuilder: (BuildContext context, int index) {
                final bool isMultiPath =
                    paths != null && paths!.isNotEmpty;
                // final int fileNo = index + 1;
                name = (isMultiPath
                    ? paths!.keys.toList()[index]
                    : fileName ?? '...');
                filePath = isMultiPath
                    ? paths!.values.toList()[index].toString()
                    : path;
                return ListTile(
                    title: Text(name!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF4B4B4B)
                          // letterSpacing: .6
                        ))
                  // subtitle: new Text(filePath),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
              new Container(),
            )),
      )
          : new Container(),
    );
  }
}
