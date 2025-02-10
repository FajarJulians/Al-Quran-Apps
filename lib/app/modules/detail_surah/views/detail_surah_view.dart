// ignore_for_file: deprecated_member_use

import 'package:al_quran/app/constants/color.dart';
import 'package:al_quran/app/data/models/detail_surah.dart' as detail_surah;
import 'package:al_quran/app/data/models/surah.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  final Surah surah = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SURAH ${surah.name?.transliteration?.id?.toUpperCase()}'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
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
                    color:
                        Get.isDarkMode ? appPurple.withOpacity(0.3) : appWhite,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Tafsir ${surah.name?.transliteration?.id}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        surah.tafsir?.id ?? 'Tidak ada tafsir',
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: Container(
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
                      "${surah.name?.transliteration?.id?.toUpperCase()} | ${surah.name!.translation?.id?.toUpperCase()}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: appWhite,
                      ),
                    ),
                    Text(
                      "${surah.numberOfVerses} Ayat - ${surah.revelation?.id}",
                      style: TextStyle(
                          fontSize: 14,
                          color: appWhite,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          FutureBuilder<detail_surah.DetailSurah>(
            future: controller.getDetailSurah(surah.number.toString()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data!.verses == null) {
                return Center(
                  child: Text("Data Tidak Ditemukan"),
                );
              }

              // Hapus Expanded karena ListView sudah fleksibel
              return ListView.builder(
                shrinkWrap: true,
                physics:
                    NeverScrollableScrollPhysics(), // Agar tidak konflik dengan ListView utama
                itemCount: snapshot.data!.verses?.length ?? 0,
                itemBuilder: (context, index) {
                  detail_surah.Verse? ayat = snapshot.data!.verses?[index];
                  if (ayat == null) {
                    return SizedBox(); // Menghindari error jika null
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
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
                              Container(
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
                                  child: Text("${index + 1}"),
                                ),
                              ),
                              GetBuilder<DetailSurahController>(
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
                                                      icon: Icon(
                                                          Icons.play_arrow),
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
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
