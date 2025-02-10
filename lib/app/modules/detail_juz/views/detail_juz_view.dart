// ignore_for_file: deprecated_member_use

import 'package:al_quran/app/constants/color.dart';
import 'package:al_quran/app/data/models/juz.dart' as juz;
import 'package:al_quran/app/data/models/surah.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  final juz.Juz detailJuz = Get.arguments["juz"];
  final List<Surah> allSurahInJuz = Get.arguments["surah"];
  @override
  Widget build(BuildContext context) {
    // allSurahInJuz.forEach((element) {
    //   print(element.name!.transliteration!.id);
    // });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Juz - ${detailJuz.juz}",
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(20),
            itemCount: detailJuz.verses.length,
            itemBuilder: (context, index) {
              if (detailJuz.verses.isEmpty) {
                return Center(
                  child: Text("Data Tidak Ditemukan"),
                );
              }
              juz.Verse ayat = detailJuz.verses[index];

              if (index != 0) {
                if (ayat.number.inSurah == 1 &&
                    controller.currentIndex < allSurahInJuz.length - 1) {
                  controller.currentIndex++;
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (ayat.number.inSurah == 1)
                    GestureDetector(
                      onTap: () => Get.dialog(
                        Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Get.isDarkMode
                                  ? appPurple.withOpacity(0.3)
                                  : appWhite,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Tafsir ${controller.currentIndex < allSurahInJuz.length ? allSurahInJuz[controller.currentIndex].name?.transliteration?.id : "Data Tidak Ditemukan"}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    ayat.tafsir.id.long,
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        width: Get.width,
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [appPurpleLight, appPurpleDark],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                "${allSurahInJuz[controller.currentIndex].name?.transliteration?.id?.toUpperCase()} ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: appWhite,
                                ),
                              ),
                              Text(
                                "( ${allSurahInJuz[controller.currentIndex].name!.translation?.id?.toUpperCase()} )",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: appWhite,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "${allSurahInJuz[controller.currentIndex].numberOfVerses} Ayat | ${allSurahInJuz[controller.currentIndex].revelation?.id}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: appWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: appPurpleLight.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      Get.isDarkMode
                                          ? "assets/images/list_dark.png"
                                          : "assets/images/list_light.png",
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${ayat.number.inSurah}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                allSurahInJuz[controller.currentIndex]
                                        .name!
                                        .transliteration!
                                        .id ??
                                    "",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          GetBuilder<DetailJuzController>(
                            builder: (cont) => Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.bookmark_add_outlined),
                                ),
                                (ayat.kondisiAudio == "stop")
                                    ? IconButton(
                                        onPressed: () {
                                          cont.playAudio(ayat);
                                        },
                                        icon: Icon(Icons.play_arrow),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (ayat.kondisiAudio == "playing")
                                              ? IconButton(
                                                  onPressed: () {
                                                    cont.pauseAudio(ayat);
                                                  },
                                                  icon: Icon(Icons.pause),
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    cont.resumeAudio(ayat);
                                                  },
                                                  icon: Icon(Icons.play_arrow),
                                                ),
                                          IconButton(
                                            onPressed: () {
                                              cont.stopAudio(ayat);
                                            },
                                            icon: Icon(Icons.stop),
                                          )
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    textAlign: TextAlign.end,
                    ayat.text.arab,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "me_quran",
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.end,
                    ayat.text.transliteration.en,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    ayat.translation.id,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
