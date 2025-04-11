import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:permission_handler/permission_handler.dart';



class AlbumController extends GetxController{
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer player = AudioPlayer();
  final AlbumModel albumModel = AlbumModel(Map());
  var albums = <AlbumModel>[].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkPermissionsAndLoadSongs();
  }
  Future<void> checkPermissionsAndLoadSongs() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      fetchAlbums();
    } else {
      Get.snackbar("Permission denied", "File access required");
    }
  }
    Future<void> fetchAlbums() async {
    List<AlbumModel> fetchedAlbums = await _audioQuery.queryAlbums(
      orderType: OrderType.DESC_OR_GREATER,
    );
    List<AlbumModel> _album = fetchedAlbums.where((album) => album.artist != "<unknown>").toList();
    List<AlbumModel> prioritizedAlbum = [
      ..._album,
      ...fetchedAlbums.where((album) => album.artist == "<unknown>"),
    ];
    albums.assignAll(prioritizedAlbum);
  }


}