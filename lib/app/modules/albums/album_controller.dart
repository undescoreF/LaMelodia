import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:melodia/app/modules/songs/song_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class AlbumController extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final SongsController songsController = Get.find<SongsController>();
  final AlbumModel albumModel = AlbumModel(Map());
  var currentAlbumSongs = <SongModel>[].obs;
  var isLoading = true.obs;
  var albums = <AlbumModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        Get.snackbar("Permission required", "Please grant storage access");
      }
      else{
        fetchAlbums();
      }
    } catch (e) {
      Get.snackbar("Error", "Permission check failed");
    }
  }
  Future<void> fetchAlbums() async {
    isLoading(true);
    List<AlbumModel> fetchedAlbums = await _audioQuery.queryAlbums(
      orderType: OrderType.DESC_OR_GREATER,
    );
    List<AlbumModel> _album = fetchedAlbums.where((album) => album.artist != "<unknown>").toList();
    List<AlbumModel> prioritizedAlbum = [
      ..._album,
      ...fetchedAlbums.where((album) => album.artist == "<unknown>"),
    ];
    albums.assignAll(prioritizedAlbum);
    isLoading(false);
  }


    Future<void> loadAlbumSongs(int albumId) async {
    try {
      isLoading(true);
      currentAlbumSongs.value = await _audioQuery.queryAudiosFrom(
        AudiosFromType.ALBUM_ID,
        albumId.toString(),
      );

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Get.snackbar("Error", "Failed to load album songs");
    }
  }

  Future<void> playAlbumSong(int index) async {
    if (index >= 0 && index < currentAlbumSongs.length) {
      final song = currentAlbumSongs[index];
      await songsController.playSong(
        song.uri!,
        song.title,
        index,
      );
    }
  }
}