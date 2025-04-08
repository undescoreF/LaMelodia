import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodia/app/modules/songs/song_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../theme/color.dart';

class MiniView extends StatelessWidget {
  final SongsController controller;
  const MiniView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final song = controller.songs[controller.songIndex.value];

      return ListTile(
        leading: QueryArtworkWidget(
          id: song.id,
          type: ArtworkType.AUDIO,
          nullArtworkWidget: const Icon(Icons.music_note, color: Colors.white, size: 40),
        ),
        title: Text(
          controller.currentSongTitle.value,
          style: const TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.artist.toString(),
          style: const TextStyle(color: Colors.white70),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Stack(
          alignment: Alignment.center,
          children: [
            Obx(() {
              controller.progress1.value = (controller.player.duration != null &&
                  controller.player.duration!.inMilliseconds > 0)
                  ? controller.progress.value
                  : 0.0;


              return CircularProgressIndicator(
                value: controller.progress1.value,
                strokeWidth: 3,
                color: AppColors.vividOrange,
                backgroundColor: AppColors.blanc,
              );
            }),
            IconButton(
              icon: Icon(controller.isPlaying.value ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                print("okokokok");
                controller.playSong(
                  song.uri!,
                  song.title,
                  controller.songIndex.value,
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
