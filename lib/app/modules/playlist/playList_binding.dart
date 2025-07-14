import 'package:get/get.dart';
import 'package:melodia/app/modules/playlist/playList_controller.dart';

class PlaylistBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<PlaylistController>(
      () => PlaylistController(),
    );
  }
}
