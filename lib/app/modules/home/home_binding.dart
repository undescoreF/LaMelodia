import 'package:get/get.dart';
import 'package:melodia/app/modules/albums/album_controller.dart';
import 'package:melodia/app/modules/playlist/playList_controller.dart';
import '../songs/song_controller.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SongsController>(() => SongsController());
    Get.lazyPut<AlbumController>(() => AlbumController());
    Get.lazyPut<PlaylistController>(() => PlaylistController());
    //Get.lazyPut<AlbumController>(() => AlbumController());
  }
}
