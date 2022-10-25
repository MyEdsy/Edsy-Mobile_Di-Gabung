import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../constants.dart';

class PilihanGandaHtml extends StatelessWidget {
  PilihanGandaHtml({
    Key? key,
    // required this.jawaban,
    // required this.jawabanBenar,
    required this.pilihan,
    required this.text,
    required this.color,
    required this.textColor,
    required this.press,
  }) : super(key: key);

  final String text, pilihan;
  // jawaban, jawabanBenar;
  final Color color, textColor;
  final VoidCallback press;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: kPrimaryColor,
          padding: EdgeInsets.all(10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: color,
        ),
        onPressed: press,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(width: 20),
            // RichText(
            //   text: TextSpan(
            //     text: pilihan,
            //     style: TextStyle(
            //       // fontSize: 12,
            //         color: textColor,
            //         fontWeight: FontWeight.bold),
            //   ),
            // ),
            Text(
              pilihan,
              style: TextStyle(
                  // fontSize: 12,
                  color: textColor,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: Html(data: text, style: {
              // p tag with text_size
              "p": Style(
                color: textColor,
              ),
            }, customRender: {
              "iframe": (RenderContext context, Widget child) {
                var attrs = context.tree.element?.attributes;
                if (attrs != null) {
                  double? width = double.tryParse(attrs['width'] ?? "");
                  double? height = double.tryParse(attrs['height'] ?? "");
                  String src = attrs['src'] ?? "";
                  String url = "https:" + src;
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
            })),
          ],
        ),
      ),
    );
  }
}
