import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:melodia/app/modules/songs/song_controller.dart';
import 'package:melodia/app/theme/color.dart';
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
                  playerController.formatDuration(playerController.player.duration!.inMilliseconds),
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

        _buildControls(context),
        _buildVolumeControl(),
      ],
    );
  }

  Widget _buildControls(BuildContext context) {
    final song = playerController.songs[playerController.songIndex.value];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.favorite, color: AppColors.blanc, size: 20.sp),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(LucideIcons.repeat, color: AppColors.blanc, size: 20.sp),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.skip_previous, color: AppColors.blanc, size: 30),
            onPressed: () {playerController.previous();},
          ),
          Obx(() => IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.vividOrange),
            ),
            icon: Icon(
              playerController.isPlaying.value ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 27.sp,
            ),
            onPressed: () {
              playerController.playSong(
                song.uri!,
                song.title,
                playerController.songIndex.value,
              );
            },
          )),
          IconButton(
            icon: Icon(Icons.skip_next, color: Colors.white, size: 30),
            onPressed: () {playerController.next();},
          ),
          IconButton(
            icon: Icon(LucideIcons.shuffle, color: AppColors.blanc, size: 20.sp),
            onPressed: () { playerController.shuffle();},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.blanc, size: 20.sp),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeControl() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(playerController.vol > 0 ? Icons.volume_down : Icons.volume_off),
            onPressed: () => playerController.setAudiovolume(0.0),
          ),
          Container(
            width: 60.w,
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 1,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
              ),
              child: Slider(
                min: 0.0,
                max: 1.0,
                value: playerController.vol.value,
                activeColor: AppColors.vividOrange,
                inactiveColor: Colors.grey,
                onChanged: playerController.setAudiovolume,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: () => playerController.setAudiovolume(1.0),
          ),
        ],
      );
    });
  }
}
