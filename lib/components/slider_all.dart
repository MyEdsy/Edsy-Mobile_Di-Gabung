import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:school_apps/model/carousel_model.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../constants.dart';
import '../main.dart';
import '../server/api.dart';

class SliderAll extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SliderAll> {
  int _current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  var isLoading = false;
  var isLoading2 = false;
  var responseJson;
  var status, code;

  List<Map<String, dynamic>> dataBanner = [];
  var data = jsonDecode(dataUserLogin);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 16, right: 16),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : dataBanner.length > 0
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 190,
                          child: Swiper(
                            onIndexChanged: (index) {
                              setState(() {
                                _current = index;
                              });
                            },
                            autoplay: true,
                            layout: SwiperLayout.DEFAULT,
                            itemCount: dataBanner.length,
                            itemBuilder: (BuildContext context, index) {
                              return GestureDetector(
                                onTap: () {
                                  // print(dataBanner[index]['file']);
                                  setState(() {
                                    detailBanner(
                                        dataBanner[index]['keterangan'],
                                        dataBanner[index]['file']);
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      // image: DecorationImage(
                                      //   fit: BoxFit.cover,
                                      //   image: NetworkImage(
                                      //     "$banner${dataBanner[index]['file']}",
                                      //   ),
                                      // )
                                    ),
                                    child: Image.network(
                                      "$banner${dataBanner[index]['file']}",
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return ClipRect(
                                          // borderRadius: BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/ban_1_1.png',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                40,
                                            // height: 170,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      // height: 170,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    )),
                              );
                            },
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 190,
                          child: Swiper(
                            onIndexChanged: (index) {
                              setState(() {
                                _current = index;
                              });
                            },
                            autoplay: false,
                            layout: SwiperLayout.DEFAULT,
                            itemCount: 1,
                            itemBuilder: (BuildContext context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: AssetImage(
                                        "assets/images/ban_1_1.png",
                                      ),
                                    )),
                              );
                            },
                          ),
                        ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: map<Widget>(
                      dataBanner,
                      (index, image) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          height: 6,
                          width: 6,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index
                                  ? kPrimaryColor
                                  : mGreyColor),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
      final response = await http.get("${getBanner}", headers: headers);
      responseJson = json.decode(response.body);
      // Future.delayed(Duration(seconds: 2)).then((value) {
      //   utilsApps.hideDialog(context);
      // });
      setState(() {
        isLoading = false;
        status = responseJson['status'];
        code = responseJson['code'];
        if (status == true && code == 200) {
          // dataMapel = responseJson['result'];
          dataBanner = List<Map<String, dynamic>>.from(
              json.decode(response.body)['result']);
        } else if (status == false && code == 403) {
          // AwesomeDialog(
          //     context: context,
          //     dialogType: DialogType.WARNING,
          //     animType: AnimType.RIGHSLIDE,
          //     headerAnimationLoop: true,
          //     title: 'Peringatan',
          //     desc: responseJson['message'],
          //     btnOkOnPress: () {},
          //     btnOkIcon: Icons.check,
          //     onDissmissCallback: (type) {
          //       //SignInScreen
          //       Navigator.pushNamedAndRemoveUntil(
          //           context, HomeSiswa.routeName, (r) => false);
          //       // Navigator.pushNamed(
          //       //     context, SignInScreen.routeName);
          //     },
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
        //       // Navigator.pushNamedAndRemoveUntil(
        //       //     context, HomeSiswa.routeName, (r) => false);
        //     },
        //     btnOkColor: kColorRedSlow)
        //     .show();
      });
    }

    return 'success';
  }

  Future detailBanner(data, img) async {
    final Completer<WebViewController> _controller =
        Completer<WebViewController>();

    return showBarModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        // isScrollControlled: true,
        // expand: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (context) {
          return ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.network(
                    "$banner${img}",
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset(
                        'assets/images/ban_1.png',
                        width: MediaQuery.of(context).size.width - 40,
                        fit: BoxFit.cover,
                      );
                    },
                    width: MediaQuery.of(context).size.width - 40,
                    fit: BoxFit.cover,
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
                  )),
              // Divider(
              //   color: kPrimaryColor,
              // ),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Html(
                      data: data,
                      onLinkTap: (url, _, __, ___) async{
                        if (await canLaunch(url!)) {
                          await launch(
                            url,
                          );
                        }
                      },
                      customRender: {
                        "iframe": (RenderContext context, Widget child) {
                          var attrs = context.tree.element?.attributes;
                          if (attrs != null) {
                            double? width =
                                double.tryParse(attrs['width'] ?? "");
                            double? height =
                                double.tryParse(attrs['height'] ?? "");
                            String src = attrs['src'] ?? "";
                            String url = "https:" + src;
                            return Container(
                                width: width ?? (height ?? 150) * 2,
                                height: height ?? (width ?? 300) / 2,
                                child: Stack(
                                  children: [
                                    WebView(
                                      initialUrl: url,
                                      javascriptMode:
                                          JavascriptMode.unrestricted,
                                      onWebViewCreated: (WebViewController
                                          webViewController) {
                                        _controller.complete(webViewController);
                                      },
                                      onPageFinished: (String url) {
                                        print('Page finished loading: $url');
                                        setState(() {
                                          isLoading2 = false;
                                        });
                                      },
                                      onPageStarted: (str) {
                                        print('start');
                                        setState(() {
                                          isLoading2 = true;
                                        });
                                      },
                                    ),
                                    isLoading2
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Stack(),
                                  ],
                                ));
                          } else {
                            return Container(height: 0);
                          }
                        }
                      }))
            ],
          );
        });
  }
}
