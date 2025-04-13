import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:melodia/app/modules/albums/album_controller.dart';
import 'package:melodia/app/theme/color.dart';
import 'package:melodia/app/widgets/player/blurred_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sizer/sizer.dart';

class AlbumView extends StatelessWidget {
  final AlbumModel album;
  final AlbumController controller = Get.put(AlbumController());

  AlbumView({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    // Charge les chansons au premier affichage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadAlbumSongs(album.id);
    });

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            BlurredBackground(artworkFuture: OnAudioQuery().queryArtwork(album.id, ArtworkType.ALBUM),
              blurIntensity: 70
            ),
            // Artwork principal
            QueryArtworkWidget(
              id: album.id,
              type: ArtworkType.ALBUM,
              artworkHeight: 35.h,
              artworkWidth: 100.w,
              size: 1024,
              artworkBorder: BorderRadius.circular(20),
              artworkFit: BoxFit.cover,
              nullArtworkWidget: Container(
                width: 100.w,
                height: 40.h,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/images/note.jpeg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ).paddingOnly(top: 7.h, left: 8.w, right: 8.w),

            // Titre de l'album (avec marquee si trop long)
            Center(
              child: album.album.length >= 30
                  ? SizedBox(
                height: 30,
                child: Marquee(
                  text: album.album,
                  style: Theme.of(context).textTheme.titleLarge,
                  scrollAxis: Axis.horizontal,
                  blankSpace: 50.0,
                  velocity: 30.0,
                  pauseAfterRound: const Duration(seconds: 1),
                ),
              )
                  : Text(
                album.album,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            // Nombre de chansons
            Center(
              child: Text(
                "${album.numOfSongs} Song(s)",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ).paddingOnly(top: 8.h),

            ListView.builder(
              padding: EdgeInsets.only(top: 55.h),
              itemCount: controller.currentAlbumSongs.length,
              itemBuilder: (context, index) {
                final song = controller.currentAlbumSongs[index];
                return ListTile(
                  leading: QueryArtworkWidget(
                    id: song.id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/note.jpeg"),
                    ),
                  ),
                  title: Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    "${song.artist} • ${controller.songsController.formatDuration(song.duration ?? 0)}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onTap: () async {
                    await controller.songsController.loadPlaylist(controller.currentAlbumSongs);
                    controller.playAlbumSong(index);
                  },
                );
              },
            ),
          ],
        );
      }),
    );
  }
}