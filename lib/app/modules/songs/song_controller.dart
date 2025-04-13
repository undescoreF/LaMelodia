import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class SongsController extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer player = AudioPlayer();
  final DraggableScrollableController sheetController = DraggableScrollableController();
  // Variables observables
  var songs = <SongModel>[].obs;
  var displayedSongs = <SongModel>[].obs;
  var isPlaying = false.obs;
  var currentIndex = 0.obs;
  var currentSongTitle = "".obs;
  var progress = 0.0.obs;
  var progress1 = 0.0.obs;
  var volume = 0.5.obs;
  var isExpanded = false.obs;
  var isShuffled = false.obs;
  var isRepeating = false.obs;
  var isLoading = true.obs;
  RxInt currentAudioPosition = 0.obs;

  @override
  void onInit() {
    super.onInit();
    volume.value = 0.5;
    setupPlayerListeners();
    checkPermissionsAndLoadSongs();
  }

  void setupPlayerListeners() {
    player.positionStream.listen((position) {
      final duration = player.duration;
      if (duration != null && duration.inMilliseconds > 0) {
        progress.value = position.inMilliseconds / duration.inMilliseconds;
        currentAudioPosition.value = position.inMilliseconds;
      }
    });

    player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });

    player.currentIndexStream.listen((index) {
      if (index != null) {
        currentIndex.value = index;
        currentSongTitle.value = songs[index].title;
      }
    });
  }

  Future<void> loadPlaylist(List<SongModel> songList, {bool autoPlay = false}) async {
    try {
      isLoading(true);
      if (listEquals(songs, songList)) return;

      songs.assignAll(songList);
      displayedSongs.value = songList;

      await player.setAudioSource(
        ConcatenatingAudioSource(
          children: songList.map((song) => AudioSource.uri(Uri.parse(song.uri!))).toList(),
          useLazyPreparation: true,
        ),
        preload: true,
      );

      if (autoPlay && songList.isNotEmpty) {
        await playSong(songList.first.uri!, songList.first.title, 0);
      }
      isLoading(false);
    } catch (e) {
      isLoading(false);
      Get.snackbar("Erreur", "Impossible de charger la playlist");
    }
  }

  Future<void> checkPermissionsAndLoadSongs() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      await fetchSongs();
    } else {
      Get.snackbar("Permission denied", "File access required");
    }
  }

  Future<void> fetchSongs() async {
    try {
      final fetchedSongs = await _audioQuery.querySongs(
        sortType: SongSortType.DATE_ADDED,
        orderType: OrderType.DESC_OR_GREATER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      final mp3Songs = fetchedSongs.where((song) => song.fileExtension == "mp3").toList();
      await loadPlaylist(mp3Songs);
      displayedSongs.value = songs.value;
    } catch (e) {
      Get.snackbar("Erreur", "Échec du chargement des chansons");
    }
  }


  Future<void> playSong(String uri, String title, int index) async {
    try {
      if (player.playing && currentIndex.value == index && currentSongTitle.value != title) {
        await player.pause();
      } else {
        if (currentIndex.value != index) {
          await player.seek(Duration.zero, index: index);
        }
        await player.play();
        currentSongTitle.value = title;
        currentIndex.value = index;
        currentSongTitle.value = title;
      }
    } catch (e) {
      Get.snackbar("Erreur", "Impossible de lire la musique");
    }
  }


  // Méthodes utilitaires
  void togglePlayer() => isExpanded.value = !isExpanded.value;

  void setVolume(double volume) {
    player.setVolume(volume);
    this.volume.value = volume;
  }

  void pauseSong() => player.playing ? player.pause() : player.play();

  void stopSong() {
    player.stop();
    isPlaying.value = false;
    currentSongTitle.value = "";
  }

  Future<void> next() async {
    if (player.hasNext) {
      await player.seekToNext();
      await player.play();
    }
  }

  Future<void> previous() async {
    if (player.hasPrevious) {
      await player.seekToPrevious();
      await player.play();
    }
  }

  Future<void> shuffle() async {
    isShuffled.value = !isShuffled.value;
    await player.setShuffleModeEnabled(isShuffled.value);
    if (isShuffled.value) await player.shuffle();
    updateDisplayedSongs();
  }

  void updateDisplayedSongs() {
    displayedSongs.value = player.shuffleModeEnabled
        ? player.shuffleIndices?.map((i) => songs[i]).toList() ?? songs
        : songs;
  }

  void toggleRepeat() {
    isRepeating.value = !isRepeating.value;
    player.setLoopMode(isRepeating.value ? LoopMode.one : LoopMode.off);
  }

  Future<void> shareSong(SongModel song) async {
    final file = File(song.data);
    if (await file.exists()) {
      await Share.shareXFiles([XFile(file.path)]);
    }
  }

  String formatDuration(int milliseconds) {
    final seconds = (milliseconds / 1000).round();
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}