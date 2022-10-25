import 'package:flutter/widgets.dart';
import 'package:school_apps/screens/features/guru/sub_manajemen_penilaian/input_nilai/siswa/componenets/component_siswa.dart';
import 'package:school_apps/screens/features/guru/sub_manajemen_penilaian/input_nilai/siswa/componenets/search_field.dart';

import '../../../../../../../constants.dart';
import '../siswa_screen.dart';


class Body extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<Body> {


  @override
  Widget build(BuildContext context) {
    print(ListNilaiSiswa.dataMapel);
    return Container(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          // Promos Section
          // SearchField(),
          SizedBox(
            height: 12,
          ),
          Container(
            padding: EdgeInsets.only(left: 18, top: 16, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ListNilaiSiswa.dataMapel['Namamapel'], style: mTitleStyle,),
                Text('${ListNilaiSiswa.dataMapel['KelompokKelas']} ${ListNilaiSiswa.dataMapel['Jurusan']} ${ListNilaiSiswa.dataMapel['NamaKelompokKelas']}',
                  style: mTitleStyle,),
              ],
            ),
          ),
          TableSiswa()
        ],
      ),
    );
  }
}