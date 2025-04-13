import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:get/get.dart';
import 'package:melodia/app/theme/color.dart';
import 'package:melodia/app/modules/songs/song_controller.dart';
import 'package:sizer/sizer.dart';

class ControlsWidget extends StatelessWidget {
  final SongsController playerController;

  const ControlsWidget({super.key, required this.playerController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentSong = playerController.songs.isNotEmpty &&
          playerController.currentIndex.value < playerController.songs.length
          ? playerController.songs[playerController.currentIndex.value]
          : null;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bouton Favori
            IconButton(
              icon: Icon(Icons.favorite, color: AppColors.blanc, size: 20.sp),
              onPressed: () {},
            ),

            // Bouton Répétition
            IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    playerController.isRepeating.value
                        ? AppColors.vividOrange
                        : Colors.transparent
                ),
              ),
              icon: Icon(LucideIcons.repeat, color: AppColors.blanc, size: 20.sp),
              onPressed: playerController.toggleRepeat,
            ),

            IconButton(
              icon: Icon(Icons.skip_previous, color: AppColors.blanc, size: 30),
              onPressed: playerController.previous,
            ),


            IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.vividOrange),
              ),
              icon: Icon(
                playerController.isPlaying.value ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 27.sp,
              ),
              onPressed: () {
                if (currentSong != null) {
                  playerController.pauseSong();
                }
              },
            ),


            IconButton(
              icon: Icon(Icons.skip_next, color: Colors.white, size: 30),
              onPressed: playerController.next,
            ),


            IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    playerController.isShuffled.value
                        ? AppColors.vividOrange
                        : Colors.transparent
                ),
              ),
              icon: Icon(LucideIcons.shuffle, color: AppColors.blanc, size: 20.sp),
              onPressed: playerController.shuffle,
            ),

            if (currentSong != null) IconButton(
              icon: Icon(LucideIcons.share2, color: AppColors.blanc, size: 20.sp),
              onPressed: () => playerController.shareSong(currentSong),
            ),
          ],
        ),
      );
    });
  }
}