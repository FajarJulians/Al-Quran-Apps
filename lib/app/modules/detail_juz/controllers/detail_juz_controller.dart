import 'package:al_quran/app/data/models/juz.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class DetailJuzController extends GetxController {
  int currentIndex = 0;

  final player = AudioPlayer();

  Verse? lastVerse;

  void playAudio(Verse ayat) async {
    // Play Audio
    if (ayat.audio.primary.isNotEmpty) {
      try {
        lastVerse ??= ayat;
        lastVerse!.kondisiAudio = "stop";
        lastVerse = ayat;
        lastVerse!.kondisiAudio = "stop";
        update();
        await player.stop();
        await player.setUrl(ayat.audio.primary);
        ayat.kondisiAudio = "playing";
        update();

        await player.play();
        ayat.kondisiAudio = "stop";
        update();

        await player.stop();
      } on PlayerException catch (e) {
        Get.snackbar("Error message", e.message.toString());
      } on PlayerInterruptedException catch (e) {
        Get.snackbar(
          "Periksa Jaringan Anda",
          e.message.toString(),
        );
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak Dapat Memutar Audio");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Audio tidak ditemukan");
    }
  }

  void pauseAudio(Verse ayat) async {
    // Pause Audio
    try {
      // Get.snackbar("Berhasil", "Memutar Audio");
      await player.pause();
      ayat.kondisiAudio = "pause";
      update();
    } on PlayerException catch (e) {
      Get.snackbar("Error message", e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.snackbar(
        "Periksa Jaringan Anda",
        e.message.toString(),
      );
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Tidak Dapat Pause Audio");
    }
  }

  void resumeAudio(Verse ayat) async {
    // Pause Audio
    try {
      ayat.kondisiAudio = "playing";

      await player.play();
      update();
      ayat.kondisiAudio = "stop";
      update();
    } on PlayerException catch (e) {
      Get.snackbar("Error message", e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.snackbar(
        "Periksa Jaringan Anda",
        e.message.toString(),
      );
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Tidak Dapat Resume Audio");
    }
  }

  void stopAudio(Verse ayat) async {
    // Pause Audio
    try {
      await player.stop();
      ayat.kondisiAudio = "stop";
      update();
    } on PlayerException catch (e) {
      Get.snackbar("Error message", e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.snackbar(
        "Periksa Jaringan Anda",
        e.message.toString(),
      );
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Tidak Dapat Stop Audio");
    }
  }

  @override
  void onClose() {
    player.stop();
    player.dispose();
    super.onClose();
  }
}
