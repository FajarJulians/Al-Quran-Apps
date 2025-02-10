import 'dart:convert';

import 'package:al_quran/app/data/models/detail_surah.dart';
import 'package:al_quran/app/data/models/surah.dart';
import 'package:http/http.dart' as http;

void main() async {
  Uri url = Uri.parse("https://api.quran.gading.dev/surah");
  var res = await http.get(url);

  List data = (json.decode(res.body) as Map<String, dynamic>)["data"];

  //1-114 == 0-113
  // print(data[113]["number"]); //114

  //data dari api (raw data) -> model (data yang sudah diolah)
  Surah surah = Surah.fromJson(data[113]);

  // // print(surah.toJson()); //An-Nas
  // print("====================================");
  // print(surah.name.short); //An-Nas
  // print("====================================");
  // print(surah.name.long); //An-Nas

  Uri urlDetail =
      Uri.parse("https://api.quran.gading.dev/surah/${surah.number}");
  var resDetail = await http.get(urlDetail);

  Map<String, dynamic> dataDetail =
      (json.decode(resDetail.body) as Map<String, dynamic>)["data"];

  //data dari api (raw data) -> model (data yang sudah diolah)
  // ignore: unused_local_variable
  DetailSurah detailSurah = DetailSurah.fromJson(dataDetail);
}
