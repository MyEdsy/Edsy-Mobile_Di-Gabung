import 'dart:convert';

List<NilaiModel> genderModelFromJson(String str) => List<NilaiModel>.from(
    json.decode(str).map((x) => NilaiModel.fromJson(x)));

String genderModelToJson(List<NilaiModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NilaiModel {
  NilaiModel({
    required this.jumlah,
    required this.nilai,
  });

  int jumlah;
  String nilai;

  factory NilaiModel.fromJson(Map<String, dynamic> json) => NilaiModel(
    nilai: json["nilai"],
    jumlah: json["jumlah"],
  );

  Map<String, dynamic> toJson() => {
    "nilai": nilai,
    "jumlah": jumlah,
  };
}
