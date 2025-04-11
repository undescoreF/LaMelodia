import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodia/app/modules/albums/album_controller.dart';
import 'package:melodia/app/modules/albums/album_list_view.dart';
import 'package:melodia/app/modules/home/home_content.dart';
import 'package:melodia/app/widgets/player/mini_player.dart';
import '../../widgets/bottom_bar.dart';
import '../songs/song_controller.dart';
import '../songs/songs_view.dart';
import 'home_controller.dart';
class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final SongsController playerController = Get.find<SongsController>();
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: (index) {
              controller.selectedIndex.value = index;
            },
            children: [
              SongView(),
              HomeContent(),
              AlbumListView(),
              HomeContent(),
              HomeContent(),
            ],
          ),
          Obx(() {
            return playerController.currentSongTitle.value.isNotEmpty
                ? DraggableScrollableSheet(
                snap: true,
                //expand: true,
                initialChildSize: 0.1, // Mini lecteur
                minChildSize: 0.1,
                maxChildSize: 1.0, // Grand lecteur
                builder: (context, scrollController) {
                  return MiniPlayer(scrollController: scrollController);
              },
            )
                : SizedBox.shrink();
          }),
        ],
      ),
      bottomNavigationBar: Obx(() => CustomBottomBar(
        pageController: controller.pageController,
        currentIndex: controller.selectedIndex.value,
      )),
    );
  }
}

