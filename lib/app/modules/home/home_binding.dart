import 'package:get/get.dart';
import '../songs/song_controller.dart';
import 'home_controller.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SongsController>(() => SongsController());
  }
}
