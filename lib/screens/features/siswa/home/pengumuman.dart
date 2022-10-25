import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:school_apps/components/headers_pengumuman.dart';
import 'package:school_apps/screens/features/guru/home_guru.dart';
import 'package:school_apps/screens/features/siswa/home_siswa.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../constants.dart';

class DetailPengumumanSiswa extends StatefulWidget {
  static String routeName = "/pengumuman_siswa";
  @override
  State createState() => _DetailPengumumanSiswa();
}

class _DetailPengumumanSiswa extends State<DetailPengumumanSiswa> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getEffect();
  }

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    // getEffect();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
        // Setting up AppBar
        appBar: AppBar(
          backgroundColor: mBackgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.blueGrey,
            onPressed: () {
              _onBackPressed();
            },
          ),
          automaticallyImplyLeading: false,
          title: HeadersForPengumuman(args['judul']),
          elevation: 0,
        ),
        backgroundColor: mBackgroundColor,
        // body: isLoading ? buildEffect() : Body()
        body: Container(
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              // Promos Section
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  args['judul'],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: mTitleStyle16,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Html(data: args['isi_pengumuman'], customRender: {
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
              })
              // Tugas(),
              // SizedBox(
              //   height: 12,
              // ),
            ],
          ),
        ));
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeSiswa()),
    );
    return Future.value(true);
  }
}
