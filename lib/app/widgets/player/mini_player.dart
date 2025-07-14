import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodia/app/modules/songs/song_controller.dart';
import 'package:melodia/app/widgets/player/blurred_background.dart';
import 'package:melodia/app/widgets/player/expanded_view.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniPlayer extends StatelessWidget {
  final ScrollController scrollController;
  final SongsController playerController = Get.find<SongsController>();

  MiniPlayer({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final song = playerController.songs[playerController.currentIndex.value];

      return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: Stack(
            children: [
              BlurredBackground(
                artworkFuture:
                    OnAudioQuery().queryArtwork(song.id, ArtworkType.AUDIO),
              ),
              ExpandedView(
                scrollController: scrollController,
                playerController: playerController,
              ),
            ],
          ),
        ),
      );
    });
  }
}
