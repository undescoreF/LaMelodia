import 'package:get/get.dart';
import 'package:melodia/app/modules/songs/song_controller.dart';

class SongsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SongsController>(() => SongsController());
  }
}
