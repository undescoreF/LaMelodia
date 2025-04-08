import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/home/home_controller.dart';


class CustomBottomBar extends StatelessWidget {
  final PageController pageController;
  final int currentIndex; // Ajoute cette propriété

  const CustomBottomBar({
    super.key,
    required this.pageController,
    required this.currentIndex, // Ajoute cette propriété
  });

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return BottomNavigationBar(
      currentIndex: currentIndex, // Utilise l'index fourni
      onTap: (index) => controller.changeTab(index),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.music_note_outlined), label: 'Songs'),
        BottomNavigationBarItem(icon: Icon(Icons.library_music_outlined), label: 'Albums'),
        BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined), label: 'Artists'),
        BottomNavigationBarItem(icon: Icon(Icons.playlist_play_outlined), label: 'PlayList'),
      ],
    );
  }
}
