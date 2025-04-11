import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class SongsController extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer player = AudioPlayer();
  var songs = <SongModel>[].obs;
  var displayedSongs = <SongModel>[].obs;
  var isPlaying = false.obs;
  bool isListening = false;
  RxInt songIndex = 0.obs;
  var isExpanded = false.obs;
  var repeatSound = false.obs;
  var currentSongTitle = "".obs;
  var shuffled = false.obs;
  RxInt currentPos = 0.obs;
  var vol = 0.0.obs;
  RxDouble progress = 0.0.obs;
  RxDouble progress1 = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermissionsAndLoadSongs();
    vol.value =0.5;
    player.positionStream.listen((position) {
      final duration = player.duration;
      if (duration != null && duration.inMilliseconds > 0) {
        progress.value = position.inMilliseconds / duration.inMilliseconds;
        currentPos.value = position.inMilliseconds;

      }
    });
    // Écoute l'état du lecteur (lecture/pause)
    player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });

  }

  // Initialiser la playlist
  Future<void> loadPlaylist(List<SongModel> songList) async {
    try {
      final uris = songList.map((song) => song.uri).toList();
      await player.setAudioSource(

        ConcatenatingAudioSource(
          children: uris.map((uri) => AudioSource.uri(Uri.parse(uri!))).toList(),
          useLazyPreparation: true,
        ),
        initialIndex: 0,
        preload: true,
      );


    } catch (e) {
      Get.snackbar("Erreur", "Impossible de charger la playlist");
      print("Erreur loadPlaylist(): $e");
    }
  }


  Future<void> checkPermissionsAndLoadSongs() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      fetchSongs();
    } else {
      Get.snackbar("Permission denied", "File access required");
    }
  }

  Future<void> fetchSongs() async {
    List<SongModel> fetchedSongs = await _audioQuery.querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    List<SongModel> mp3Songs = fetchedSongs.where((song) => song.fileExtension == "mp3").toList();
   /* List<SongModel> prioritizedSongs = [
      ...mp3Songs,
      ...fetchedSongs.where((song) => song.fileExtension != "mp3"),
    ];*/
   // songs.assignAll(prioritizedSongs);
    //await loadPlaylist(prioritizedSongs);
    songs.assignAll(mp3Songs);await loadPlaylist(mp3Songs);
    displayedSongs.value=songs.value;
  }

  Future<void> playSong(String uri, String title, int id) async {
    try {
      if (player.playing && songIndex.value == id) {
        await player.pause();
      } else {
        if (songIndex.value != id || (songIndex.value==0&&id==0)) {
          songIndex.value = id;
          await player.seek(Duration.zero, index: id);
          if (!isListening) {

            player.currentIndexStream.listen((index) {
              if (index != null) {
                songIndex.value = index;
                currentSongTitle.value = songs[index].title;
                update();
              }
            });
            isListening = true;
          }
        }
        await player.play();
        currentSongTitle.value = title;
      }
      isPlaying.value = player.playing;
    } catch (e) {
      Get.snackbar("Erreur", "Impossible de lire la musique");
      print("Erreur playSong(): $e");
    }
  }
  void togglePlayer() {
    isExpanded.value = !isExpanded.value;
  }
  void setAudiovolume(double volume){
    player.setVolume(volume);
    vol.value = player.volume;
  }
  void pauseSong(){
    if(isPlaying.value){
      player.pause();
    } else {
      player.play();
    }
  }
  void stopSong() {
    player.stop();
    isPlaying.value = false;
    currentSongTitle.value = "";
  }
  void next() async {
    if (player.hasNext) {
      player.seekToNext();
      songIndex.value++;
      currentSongTitle.value = songs[songIndex.value].title;
      player.play();
    } else {
      print("Aucune chanson suivante.");
    }
  }
  void previous() {
    if (player.hasPrevious) {
      player.seekToPrevious();
      songIndex.value--;
      currentSongTitle.value = songs[songIndex.value].title;
      player.play();
    } else {
      print("Aucune chanson précédente.");
    }
  }
  void shuffle() async {

    try {
      shuffled.value = !shuffled.value;
      shuffled.value ? await player.setShuffleModeEnabled(true) : await player.setShuffleModeEnabled(false) ;
      await player.shuffle();
      if (player.shuffleIndices != null) {
        displayedSongs.value = player.shuffleModeEnabled
            ? player.shuffleIndices!.map((i) => songs[i]).toList()
            : songs;
      }
      update();
    } catch (e) {
      Get.snackbar("Error", "Failed to shuffle playlist");
      print("Shuffle error: $e");
    }
  }

  //
  void repeat(){
     repeatSound.value = !repeatSound.value;
     player.setLoopMode(repeatSound.value ?LoopMode.one : LoopMode.off);
  }



  Future<void> shareSong(SongModel song) async {

    // Vérifie si le fichier existe
    final file = File(song.data);
    if (await file.exists()) {
      await Share.shareXFiles(
        [XFile(file.path)],);
    } else {
      print("Fichier non trouvé");
    }
  }



  //formatage
  String formatDuration(int milliseconds) {
    int seconds = (milliseconds / 1000).round();
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
