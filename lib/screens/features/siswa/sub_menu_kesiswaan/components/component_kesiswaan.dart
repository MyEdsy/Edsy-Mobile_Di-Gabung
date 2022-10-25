import 'package:flutter/widgets.dart';
import 'package:school_apps/screens/features/siswa/sub_menu_kesiswaan/data_pelanggaran/menu_pelanggaran.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../constants.dart';
import '../../../../../main.dart';

class componentpelanggaran extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<componentpelanggaran> {
  _getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    tahunAjaranPref = sharedPreferences.getString("tahunAjaran");
    print(tahunAjaranPref);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, top: 0, bottom: 12),
          child: Text(
            'Silahkan Pilih Menu',
            style: mTitleStyle,
          ),
        ),
        Container(
          height: 220,
          margin: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, MenuPelanggaran.routeName),
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.only(left: 16),
                        height: 80,
                        decoration: BoxDecoration(
                          color: mFillColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: mBorderColor, width: 1),
                        ),
                        child: Row(
                          children: <Widget>[
                            Image.asset('assets/images/category.png'),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Data Pelanggaran Siswa',
                                    style: mServiceTitleStyle,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                      'Menu Pelanggaran \nDetail Pelanggaran',
                                      style: mServiceSubtitleStyle)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
