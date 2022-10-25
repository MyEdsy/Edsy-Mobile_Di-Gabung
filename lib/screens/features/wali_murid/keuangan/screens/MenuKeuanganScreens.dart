import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_apps/components/headers_for_sub_menu.dart';
import 'package:school_apps/screens/features/wali_murid/keuangan/components/MenuKeuanganComponent.dart';

import '../../../../../constants.dart';


class WaliMuridMenuKeuanganScreens extends StatelessWidget {
  static String routeName = "/walimurid_keuangan_siswa_screens";

  const WaliMuridMenuKeuanganScreens({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setting up AppBar
      appBar: AppBar(
        backgroundColor: mBackgroundColor,
        automaticallyImplyLeading: false,
        title: HeadersForMenu('Keuangan'),
        elevation: 0,
      ),
      backgroundColor: mBackgroundColor,
      body: const WaliMuridMenuKeuanganKomponen(),
    );
  }
}
