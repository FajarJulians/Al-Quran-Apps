import 'package:al_quran/app/constants/color.dart';
import 'package:al_quran/app/data/models/juz.dart' as juz;
import 'package:al_quran/app/data/models/surah.dart';
import 'package:al_quran/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) {
      controller.isDark.value = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Al-Quran Apps', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Get.toNamed(Routes.SEARCH);
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assalamualaikum',
                style: TextStyle(fontSize: 20),
              ),
              Text('Selamat Datang di Al-Quran Apps'),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [appPurpleLight, appPurpleDark],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Get.toNamed(Routes.LAST_READ);
                    },
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: -30,
                          right: 0,
                          child: Opacity(
                            opacity: 0.5,
                            child: SizedBox(
                              width: 170,
                              height: 170,
                              child: Image.asset(
                                'assets/images/alquran.png',
                                fit: BoxFit.contain,
                                // width: Get.width,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.menu_book_rounded,
                                    color: appWhite,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Terakhir dibaca",
                                    style: TextStyle(
                                      color: appWhite,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Al-Fatihah",
                                style: TextStyle(
                                  color: appWhite,
                                  // fontSize: 20,
                                ),
                              ),
                              Text(
                                "Ayat 2",
                                style: TextStyle(
                                  color: appWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              TabBar(
                tabs: [
                  Tab(
                    text: "Surah",
                  ),
                  Tab(
                    text: "Juz",
                  ),
                  Tab(
                    text: "Bookmark",
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FutureBuilder<List<Surah>>(
                      future: controller.getAllSurah(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text("Data Tidak Ditemukan"),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Surah surah = snapshot.data![index];
                            return ListTile(
                              onTap: () {
                                Get.toNamed(Routes.DETAIL_SURAH,
                                    arguments: surah);
                              },
                              leading: Obx(
                                () => Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        controller.isDark.isTrue
                                            ? "assets/images/list_dark.png"
                                            : "assets/images/list_light.png",
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text("${surah.number}"),
                                  ),
                                ),
                              ),
                              title: Text(
                                surah.name!.transliteration!.id ?? 'Unknown',
                              ),
                              subtitle: Text(
                                "${surah.numberOfVerses} Ayat | ${surah.revelation?.id}",
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                              trailing: Text(surah.name!.short ?? 'Unknown'),
                            );
                          },
                        );
                      },
                    ),
                    FutureBuilder<List<juz.Juz>>(
                      future: controller.getAllJuz(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text("Data Tidak Ditemukan"),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            juz.Juz detailJuz = snapshot.data![index];

                            String nameStart =
                                detailJuz.juzStartInfo.split(" - ").first;
                            String nameEnd =
                                detailJuz.juzEndInfo.split(" - ").first;

                            List<Surah> rawAllSurahJuz = [];
                            List<Surah> allSurahJuz = [];

                            for (Surah item in controller.surahList) {
                              rawAllSurahJuz.add(item);
                              if (item.name!.transliteration!.id == nameEnd) {
                                break;
                              }
                            }

                            for (Surah item
                                in rawAllSurahJuz.reversed.toList()) {
                              allSurahJuz.add(item);
                              if (item.name!.transliteration!.id == nameStart) {
                                break;
                              }
                            }

                            return ListTile(
                              onTap: () {
                                Get.toNamed(
                                  Routes.DETAIL_JUZ,
                                  arguments: {
                                    "juz": detailJuz,
                                    "surah": allSurahJuz.reversed.toList()
                                  },
                                );
                              },
                              leading: Obx(
                                () => Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        controller.isDark.isTrue
                                            ? "assets/images/list_dark.png"
                                            : "assets/images/list_light.png",
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text("${index + 1}"),
                                  ),
                                ),
                              ),
                              title: Text(
                                "Juz ${index + 1}",
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${detailJuz.juzStartInfo} ~ ${detailJuz.juzEndInfo}",
                                  ),
                                  Text(
                                    "${detailJuz.totalVerses} Ayat",
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Center(
                      child: Text("3"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.changeThemeMode(),
        child: Obx(
          () => Icon(
            Icons.brightness_4,
            color: controller.isDark.isTrue ? appPurpleDark : appWhite,
          ),
        ),
      ),
    );
  }
}
