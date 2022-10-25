import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:school_apps/helper/currency_format.dart';
import 'package:school_apps/screens/OnBoarding/OnBoarding.dart';
import 'package:school_apps/screens/features/siswa/home_siswa.dart';
import 'package:school_apps/screens/features/siswa/keuangan/Screens/DetailTagihanScreens.dart';
import 'package:school_apps/server/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../constants.dart';
import '../../../../../main.dart';

class TagihanScreen extends StatefulWidget {
  @override
  _TagihanScreen createState() => _TagihanScreen();
}

class _TagihanScreen extends State<TagihanScreen> {
  var isLoading = false;
  var responseJson;
  List<Map<String, dynamic>> dataTagihanSiswa = [];
  List<Map<String, dynamic>> _foundUsers = [];
  var code;
  late bool status = false;

  var data = jsonDecode(dataUserLogin);
  var dataTahunAjaran = jsonDecode(tahunAjaranPref);
  var bulan = '';
  var tgl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      children: [
        isLoading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: mGreyColor,
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (_, __) => (dummyListViewCell()),
                    itemCount: 20,
                  ),
                ),
              )
            : dataTagihanSiswa.length > 0 ?
        ListView(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          children: [
            // _search(),
            SizedBox(
              height: 15,
            ),
            ListView.separated(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: dataTagihanSiswa == null
                    ? 0
                    : dataTagihanSiswa.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 5,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return _dataTagihan(
                      '${dataTagihanSiswa[index]['no_invoice']}',
                      '${dataTagihanSiswa[index]['paket_pembayaran']['type_pembayaran']}',
                      '${dataTagihanSiswa[index]['paket_pembayaran']['nama_paket']}',
                      CurrencyFormat.convertToIdr(
                          dataTagihanSiswa[index]['grand_total'], 2),
                      '${dataTagihanSiswa[index]['bukti_bayar']}',
                      '${bulanIndo(dataTagihanSiswa[index]['tempo_bayaran'])} - ${dataTagihanSiswa[index]['tahun_bayaran']}',
                      Chip(
                        materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                        label: Text(
                          '${dataTagihanSiswa[index]['status']}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: dataTagihanSiswa[index]
                        ['status'] ==
                            'Belum Lunas'
                            ? kColorRedSlow
                            : kColorYellow,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, DetailTagihanScreens.routeName,
                              arguments: {
                                'noInvoice': dataTagihanSiswa[index]
                                ['no_invoice'],
                                'id': dataTagihanSiswa[index]['id'],
                                'id_paket_pembayaran':
                                dataTagihanSiswa[index]
                                ['id_paket_pembayaran'],
                                'type': dataTagihanSiswa[index]
                                ['paket_pembayaran']
                                ['type_pembayaran'],
                                'status': dataTagihanSiswa[index]
                                ['status'],
                                'bukti_bayar': dataTagihanSiswa[index]
                                ['bukti_bayar'],
                                'totalCicilan' : dataTagihanSiswa[index]['grand_total']
                              });
                        },
                        child: const Chip(
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          avatar: Icon(
                            FontAwesomeIcons.creditCard,
                            size: 15,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Bayar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: kPrimaryColor,
                        ),
                      ));
                }),
            SizedBox(height: 15)
          ],
        ) : Center(
          child: Container(
            child: Image.asset("assets/images/data_not_found.png"),
          ),
        )
      ],
    );
  }
  
  //data_not_found.png

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

  _dataTagihan(noInvoice, paketTagihan, namaPaket, jumlah, buktiBayar,
      jatuhTempo, status, bayar) {
    return Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        padding: EdgeInsets.all(10),
        height: 200,
        decoration: BoxDecoration(
            color: mFillColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: mBorderColor, width: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 180,
                  child: Text(
                    noInvoice,
                    overflow: TextOverflow.ellipsis,
                    style: (TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Spacer(),
                status
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width - 160,
              child: Text(
                paketTagihan,
                overflow: TextOverflow.ellipsis,
                style: (TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.box,
                  color: Colors.grey,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 160,
                  child: Text(
                    namaPaket,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.commentDollar,
                  color: Colors.grey,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 160,
                  child: Text(
                    jumlah,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.calendar,
                  color: Colors.grey,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  jatuhTempo,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                bayar,
                SizedBox(
                  width: 5,
                ),
                // bayar,
                buktiBayar == "null"
                    ? Container()
                    : Chip(
                        label: Text(
                          "ℹ️ Menungu Validasi...",
                          style: TextStyle(
                              // color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        // backgroundColor: kColorYellow,
                      ),
                SizedBox(
                  width: 5,
                ),
                // upload
              ],
            )
          ],
        ));
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
          "${tagihanPembayaran}/${data['username']}",
          headers: headers);
      responseJson = json.decode(response.body);

      setState(() {
        isLoading = false;
        status = responseJson['status'];
        code = responseJson['code'];
        if (status == true && code == 200) {
          dataTagihanSiswa = List<Map<String, dynamic>>.from(
              json.decode(response.body)['result']);
        } else if (status == false && code == 403) {
          dataTagihanSiswa = [];
        } else if(status == false && code == 401){
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
                        context, Onboarding.routerName, (r) => false);
                    final pref = await SharedPreferences.getInstance();
                    await pref.clear();
                  },
                  btnOkColor: kColorRedSlow)
              .show();
        }else {
          AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: true,
              title: 'Peringatan',
              desc: "Terjadi kesalahan pada server",
              btnOkOnPress: () {},
              btnOkIcon: Icons.cancel,
              onDissmissCallback: (type) async {
                //SignInScreen
              },
              btnOkColor: kColorRedSlow)
              .show();
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          status = false;
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
    }

    return 'success';
  }
}
