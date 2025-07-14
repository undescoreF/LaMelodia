import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodia/app/modules/songs/song_controller.dart';

import '../modules/home/home_controller.dart';

class CustomBottomBar extends StatelessWidget {
  final PageController pageController;
  final int currentIndex;

  const CustomBottomBar({
    super.key,
    required this.pageController,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        final SongsController ctrl = Get.find<SongsController>();
        controller.changeTab(index);
        ctrl.sheetController.animateTo(
          0.1,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.music_note_outlined), label: 'Songs'),
        BottomNavigationBarItem(
            icon: Icon(Icons.library_music_outlined), label: 'Albums'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        //  BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined), label: 'Artists'),
        BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play_outlined), label: 'PlayList'),
      ],
    );
  }
}
