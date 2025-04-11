import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodia/app/modules/albums/album_controller.dart';
import 'package:melodia/app/widgets/player/blurred_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sizer/sizer.dart';


class AlbumView extends StatelessWidget {
  AlbumView({super.key, required this.albumId});
  final AlbumController controller = Get.find<AlbumController>();
  int albumId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Stack(
          children: [
            BlurredBackground(artworkFuture: OnAudioQuery().queryArtwork(albumId, ArtworkType.ALBUM),blurIntensity: 70,),
            QueryArtworkWidget(
              id: albumId,
              type: ArtworkType.ALBUM,
              artworkHeight: 45.h,
              artworkWidth: 100.w,
              artworkBlendMode: BlendMode.softLight,
              size: 1024,
              keepOldArtwork: false,
              artworkBorder: BorderRadius.circular(20),
              artworkFit: BoxFit.cover,
              artworkQuality: FilterQuality.high,
              quality: 100,
              nullArtworkWidget: Container(
                width: 100.w,
                height: 40.h,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/note.jpeg")),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ).paddingOnly(top:7.h,left: 8.w, right: 8.w),
          ],
        ),
      ),
    );
  }
}
