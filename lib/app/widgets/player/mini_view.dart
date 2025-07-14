import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodia/app/modules/songs/song_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../theme/color.dart';

class MiniView extends StatelessWidget {
  final SongsController controller;
  final SongModel song;
  const MiniView({super.key, required this.controller, required this.song});

  @override
  Widget build(BuildContext context) {
    final song = this.song;
    return GestureDetector(
      onTap: () => controller.sheetController.animateTo(
        1.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
      child: ListTile(
        leading: QueryArtworkWidget(
          id: song.id,
          type: ArtworkType.AUDIO,
          nullArtworkWidget:
              const Icon(Icons.music_note, color: Colors.white, size: 40),
        ),
        title: Text(
          song.title,
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
              return CircularProgressIndicator(
                value: controller.progress.value,
                strokeWidth: 3,
                color: AppColors.vividOrange,
                backgroundColor: AppColors.blanc,
              );
            }),
            Obx(() {
              return IconButton(
                icon: Icon(controller.isPlaying.value
                    ? Icons.pause
                    : Icons.play_arrow),
                onPressed: () {
                  controller.pauseSong();
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
