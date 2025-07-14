import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';


class PlaylistController extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer player = AudioPlayer();
  //observable
  var playlists = <PlaylistModel>[].obs;
  var name = "".obs;
  @override
  void onInit() {
    super.onInit();
    loadPlayList();
  }

  Future<void> createPlayList(String name) async {
    try {
      await _audioQuery.createPlaylist(name);
      await loadPlayList();
    } catch (e) {
      print(e);
    }
  }
  Future<void> renamePlayList(int id, String newName) async {
    if (!await Permission.manageExternalStorage.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
    }
    try{
      await _audioQuery.renamePlaylist(id, newName);
      loadPlayList();
    }catch(e){
      print("Error while renaming playlist: $e");
    }
  }

  Future<void> loadPlayList() async {
    List<PlaylistModel> playlists_ = await OnAudioQuery().queryPlaylists();
    playlists.value = playlists_;
  }

  void addPlayList() {
    //_audioQuery.pla
  }
  Future<void> deleteAllPlaylists() async {
    try {
      // Vérifier la permission
      if (!await Permission.manageExternalStorage.isGranted) {
        await Permission.manageExternalStorage.request();
      }
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }

      List<PlaylistModel> allPlaylists = await _audioQuery.queryPlaylists();
      print("Nombre de playlists trouvées: ${allPlaylists.length}");
      for (final playlist in allPlaylists) {
        try {
          await _audioQuery.removePlaylist(playlist.id);
        } catch (e) {
          print("Erreur lors de la suppression de ${playlist.id}: $e");
        }
      }
      await Future.delayed(Duration(seconds: 1));
      await loadPlayList();
    } catch (e) {
      print("Erreur globale lors de la suppression : $e");
    }
  }
  Future<void>  removePlaylist(int id, String name) async {
    try{
      await _audioQuery.removePlaylist(id);
      Get.snackbar(name,"Playlist deleted successfully.");
      loadPlayList();
    }catch(e){
      Get.snackbar("Erreur", "$e");
    }
  }

}
