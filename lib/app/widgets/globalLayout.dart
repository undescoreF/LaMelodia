import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodia/app/modules/home/home_view.dart';
import 'package:melodia/app/modules/songs/song_controller.dart';
import 'package:melodia/app/widgets/player/mini_player.dart';

class GlobalLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SongsController playerController = Get.find<SongsController>();

    return Scaffold(
      body: Stack(
        children: [
          // Navigator principal avec la logique de navigation
          Navigator(
            key: Get.nestedKey(1),
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => HomeView(),
              );
            },
          ),

          // Afficher le MiniPlayer sans interférer avec le bottomNavigationBar
          Obx(() {
            return playerController.currentSongTitle.value.isNotEmpty
                ? Positioned(
                    left: 0,
                    right: 0,
                    bottom:
                        0, // Positionner le MiniPlayer en bas sans interférer
                    child: DraggableScrollableSheet(
                      snap: true,
                      expand: true,
                      // Crée un nouveau controller à chaque fois
                      controller: DraggableScrollableController(),
                      initialChildSize: 0.1,
                      minChildSize: 0.1,
                      maxChildSize: 1.0,
                      builder: (context, scrollController) {
                        return MiniPlayer(scrollController: scrollController);
                      },
                    ),
                  )
                : SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
