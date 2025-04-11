import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodia/app/modules/songs/song_controller.dart';
import 'package:melodia/app/theme/color.dart';
import 'package:melodia/app/widgets/player/control.dart';
import 'package:melodia/app/widgets/player/volume_control.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';

class ExpandedView extends StatelessWidget {
  final ScrollController scrollController;
  final SongsController playerController;

  const ExpandedView({
    super.key,
    required this.scrollController,
    required this.playerController,
  });

  @override
  Widget build(BuildContext context) {
    final song = playerController.songs[playerController.songIndex.value];

    return ListView(
      controller: scrollController,
      padding: EdgeInsets.zero,
      children: [
        if(!playerController.isExpanded.value) Container(height: 5.h,),
        QueryArtworkWidget(
          id: song.id,
          type: ArtworkType.AUDIO,
          artworkHeight: 45.h,
          artworkBlendMode: BlendMode.softLight,
          size: 1024,
          artworkBorder: BorderRadius.circular(20),
          artworkFit: BoxFit.cover,
          artworkQuality: FilterQuality.high,
          quality: 100,
          nullArtworkWidget: Container(
            width: 100.w,
            height: 45.h,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/note.jpeg")),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ).paddingOnly(top: 7.h, left: 8.w, right: 8.w),

        Obx(() {
          double progress = (playerController.player.duration != null &&
              playerController.player.duration!.inMilliseconds > 0)
              ? playerController.progress.value.clamp(0.0, 1.0)
              : 0.0;

          return SliderTheme(
            data: SliderThemeData(
              trackHeight: 1,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
            ),
            child: Slider(
              value: progress.isNaN ? 0.0 : progress,
              min: 0.0,
              max: 1.0,
              activeColor: AppColors.vividOrange,
              inactiveColor: Colors.grey,
              onChanged: (value) {
                final newPosition = Duration(
                  milliseconds: (playerController.player.duration!.inMilliseconds * value).toInt(),
                );
                playerController.player.seek(newPosition);
              },
            ),
          );
        }).paddingOnly(top: 2.h),

        Obx(() {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  playerController.formatDuration(playerController.currentPos.value),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  playerController.formatDuration(playerController.player.duration!=null ? playerController.player.duration!.inMilliseconds:0),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }),

        // Title
        Center(
          child: song.title.toString().length >= 30
              ? SizedBox(
            height: 30,
            child: Marquee(
              text: song.title,
              style: Theme.of(context).textTheme.titleLarge,
              scrollAxis: Axis.horizontal,
              blankSpace: 50.0,
              velocity: 30.0,
              pauseAfterRound: Duration(seconds: 1),
            ),
          ).paddingOnly(left: 5.w, right: 5.w, top: 1.h)
              : Text(
            song.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),

        // Subtitle
        Center(
          child: song.artist.toString().length >= 30
              ? SizedBox(
            height: 30,
            child: Marquee(
              text: song.artist.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              scrollAxis: Axis.horizontal,
              blankSpace: 50.0,
              velocity: 30.0,
              pauseAfterRound: Duration(seconds: 1),
            ),
          ).paddingOnly(left: 5.w, right: 5.w, top: 1.h)
              : Text(
            song.artist.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ).paddingOnly(top: 0.5.h),
        ),

        ControlsWidget(playerController: playerController),
        VolumeControlWidget(playerController: playerController),
      ],
    );
  }
}


