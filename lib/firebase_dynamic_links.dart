import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_apps/screens/features/siswa/keuangan/Componen/DetailTagihanComponents.dart';
import 'package:school_apps/screens/features/siswa/keuangan/Screens/TagihanScreens.dart';
import 'package:school_apps/screens/features/siswa/sub_menu_quiz_siswa/soal_quiz/response/responsejawaban.dart';

class FirebaseDynamicLinkService {
  static get noInvoice => null;

  static Future<String> createDynamicLink(
    bool short,
    TagihanScreens tagihanSiswaScreens,
  ) async {
    String _linkMessage;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://inovasidigital.page.link',
      link: Uri.parse('https://inovasidigital.page.link/tagihanSiswaScreens'),
      androidParameters: AndroidParameters(
        packageName: 'com.edsy.school_apps',
        minimumVersion: 125,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.inovasidigital.schoolApps',
        minimumVersion: '1.0.0',
        appStoreId: '1613510009',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    _linkMessage = url.toString();
    return _linkMessage;
  }

  static Future<void> initDynamicLink(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLinkData) async {
      final Uri deepLink = dynamicLinkData.link;

      var blahh = deepLink.pathSegments.contains('detailTagihanScreen');

      if (blahh) {
        String? id = deepLink.queryParameters['id'];
        print('TES>>>>>>>>>>>>>>');

        if (deepLink != null) {
          try {} catch (e) {
            print(e);
          }
        } else {
          return null;
        }
      }
    });
  }
}
