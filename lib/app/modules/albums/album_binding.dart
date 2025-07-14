import 'package:get/get.dart';
import 'package:melodia/app/modules/albums/album_controller.dart';

class AbumBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<AlbumController>(
      () => AlbumController(),
    );
  }
}
