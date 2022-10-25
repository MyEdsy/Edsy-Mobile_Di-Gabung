import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:school_apps/screens/features/wali_murid/keuangan/screens/PilihMetodePembayaran.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../constants.dart';
import '../../../../../main.dart';
import '../../../../../size_config.dart';

class WaliMuridMetodePembayaranScreen extends StatefulWidget {
  const WaliMuridMetodePembayaranScreen({Key? key}) : super(key: key);

  @override
  _WaliMuridMetodePembayaranScreen createState() =>
      _WaliMuridMetodePembayaranScreen();
}

class _WaliMuridMetodePembayaranScreen
    extends State<WaliMuridMetodePembayaranScreen> {
  var data = jsonDecode(dataUserLogin);
  var dataTahunAjaran = jsonDecode(tahunAjaranPref);

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: <Widget>[
      // TextField(
      //   decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
      //   controller: urlController,
      //   keyboardType: TextInputType.url,
      //   onSubmitted: (value) {
      //     var url = Uri.parse(value);
      //     if (url.scheme.isEmpty) {
      //       url = Uri.parse("https://www.google.com/search?q=" + value);
      //     }
      //     webViewController?.loadUrl(urlRequest: URLRequest(url: url));
      //   },
      // ),
      Expanded(
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(
                  url: Uri.parse(WaliMuridPilihMetodePembayaran.args["url"])),
              // initialUrlRequest: URLRequest(
              //     url: Uri.parse(
              //         "https://checkout.xendit.co/web/6285f20894d469af5e722273")),
              initialOptions: options,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url!;

                if (![
                  "http",
                  "https",
                  "file",
                  "chrome",
                  "data",
                  "javascript",
                  "about"
                ].contains(uri.scheme)) {
                  if (await canLaunch(url)) {
                    // Launch the App
                    await launch(
                      url,
                    );
                    // and cancel the request
                    return NavigationActionPolicy.CANCEL;
                  }
                }

                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController.endRefreshing();
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onLoadError: (controller, url, code, message) {
                pullToRefreshController.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                  urlController.text = this.url;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
            ),
            progress < 1.0
                ? LinearProgressIndicator(value: progress)
                : Container(),
          ],
        ),
      ),
      // ButtonBar(
      //   alignment: MainAxisAlignment.center,
      //   children: <Widget>[
      //     ElevatedButton(
      //       child: Icon(Icons.arrow_back),
      //       onPressed: () {
      //         webViewController?.goBack();
      //       },
      //     ),
      //     ElevatedButton(
      //       child: Icon(Icons.arrow_forward),
      //       onPressed: () {
      //         webViewController?.goForward();
      //       },
      //     ),
      //     ElevatedButton(
      //       child: Icon(Icons.refresh),
      //       onPressed: () {
      //         webViewController?.reload();
      //       },
      //     ),
      //   ],
      // ),
    ]));
  }
}
// LU ANAK KAMP*NG