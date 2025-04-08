import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodia/app/modules/songs/song_controller.dart';
import 'package:melodia/app/widgets/player/blurred_background.dart';
import 'package:melodia/app/widgets/player/expanded_view.dart';
import 'package:melodia/app/widgets/player/mini_view.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sizer/sizer.dart';


class MiniPlayer extends StatelessWidget {
  final ScrollController scrollController;
  final SongsController playerController = Get.find<SongsController>();

  MiniPlayer({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        double height = constraints.maxHeight;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          playerController.isExpanded.value = height > screenHeight * 0.2;
        });


        return Obx(() {
          final song = playerController.songs[playerController.songIndex.value];
          final isExpanded = playerController.isExpanded.value;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  BlurredBackground( artworkFuture: OnAudioQuery().queryArtwork(song.id, ArtworkType.AUDIO),),
                  if(!isExpanded)MiniView(controller: Get.find<SongsController>()),
                  ExpandedView(scrollController: scrollController, playerController: Get.find<SongsController>()),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
