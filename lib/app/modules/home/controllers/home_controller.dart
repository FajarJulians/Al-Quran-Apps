import 'dart:convert';

import 'package:al_quran/app/constants/color.dart';
import 'package:al_quran/app/data/models/juz.dart';
import 'package:al_quran/app/data/models/surah.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  List<Surah> surahList = [];

  RxBool isDark = false.obs;

  void changeThemeMode() async {
    Get.isDarkMode ? Get.changeTheme(themeLight) : Get.changeTheme(themeDark);
    isDark.toggle();

    final box = GetStorage();

    if (Get.isDarkMode) {
      // dark to light
      box.remove("themeDark");
    } else {
      // light to dark
      box.write("themeDark", true);
    }
  }

  Future<List<Surah>> getAllSurah() async {
    // Get All Surah
    Uri url = Uri.parse("https://api.quran.gading.dev/surah");
    var res = await http.get(url);

    List data = (json.decode(res.body) as Map<String, dynamic>)["data"];

    if (data.isEmpty) {
      return [];
    } else {
      surahList = data.map((e) => Surah.fromJson(e)).toList();
      return surahList;
    }
  }

  Future<List<Juz>> getAllJuz() async {
    List<Juz> juzList = [];

    for (int i = 1; i <= 30; i++) {
      try {
        Uri url = Uri.parse("https://api.quran.gading.dev/juz/$i");
        var res = await http.get(url);

        if (res.statusCode == 200) {
          Map<String, dynamic> data =
              (json.decode(res.body) as Map<String, dynamic>)["data"];
          Juz juz = Juz.fromJson(data);
          juzList.add(juz);
        } else {
          // print("Gagal mengambil data Juz $i: ${res.statusCode}");
        }
      } catch (e) {
        // print("Error saat mengambil Juz $i: $e");
      }
    }

    return juzList;
  }
}
