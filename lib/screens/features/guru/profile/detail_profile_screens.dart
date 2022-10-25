import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_apps/constants.dart';
import 'package:school_apps/screens/features/guru/profile/biodata.dart';
import 'package:school_apps/screens/features/guru/profile/ubah_password.dart';

class DetailProfileGuruScreen extends StatefulWidget {
  static String routeName = "/detail_profile_guru";
  @override
  _DetailProfileSiswaScreen createState() => _DetailProfileSiswaScreen();
}


class _DetailProfileSiswaScreen extends State<DetailProfileGuruScreen> with SingleTickerProviderStateMixin{

  //create controller untuk tabBar
  late TabController controller;

  @override

  void initState(){
    controller = TabController(vsync: this, length: 2);
    //tambahkan SingleTickerProviderStateMikin pada class _HomeState
    super.initState();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //create appBar
      appBar:  AppBar(
        //warna background
        backgroundColor: kPrimaryColor,
        //judul
        leading:  IconButton(
          icon:  const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("My Account"),
        //bottom
        bottom: TabBar(
          controller: controller,
          tabs: const <Widget>[
            Tab(icon: Icon(FontAwesomeIcons.user),),
            Tab(icon: Icon(FontAwesomeIcons.lock),),
          ],
        ),
      ),

      //source code lanjutan
      //buat body untuk tab viewnya
      body: TabBarView(
        //controller untuk tab bar
        controller: controller,
        children: <Widget>[
          //kemudian panggil halaman sesuai tab yang sudah dibuat
          Biodata(),
          UbahPasswordGuru()
        ],
      ),
    );
  }
}
