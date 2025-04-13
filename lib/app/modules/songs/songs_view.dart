import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:melodia/app/data/song_model.dart';
import 'package:melodia/app/modules/songs/song_controller.dart';
import 'package:melodia/app/theme/color.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sizer/sizer.dart';
class SongView extends StatefulWidget {
  const SongView({super.key});

  @override
  State<SongView> createState() => _SongViewState();
}

class _SongViewState extends State<SongView> {
  bool search = false ;
  @override
  Widget build(BuildContext context) {
    final SongsController controller = Get.find<SongsController>();
    return Scaffold(
      backgroundColor: AppColors.darkBlueGray,
      appBar:  search ? AppBar(
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.vividOrange),
       //backgroundColor: Colors.white,
        title: SizedBox(
          height: 7.h,
          child: SearchBar(
          //  backgroundColor:WidgetStatePropertyAll(Colors.white),
            side: WidgetStatePropertyAll(BorderSide(color: AppColors.vividOrange,width: 1)),
            hintText: "Search...",
            leading: IconButton(
                onPressed:() => setState(() {search=false;}),
                icon:Icon(LucideIcons.arrowLeft, size: 15,)).paddingOnly(right: 3.w),
            trailing: [
              Icon(LucideIcons.search, size: 15,).paddingOnly(right: 5.w)
            ],
          ),
        ).paddingOnly(top: 2.h),
        centerTitle: false,
        toolbarHeight: 10.h,
        actions: [
          Icon(LucideIcons.listFilterPlus, size: 30,).paddingOnly(right: 5.w).paddingOnly(top: 2.h)
        ],
      ) : AppBar(
        iconTheme: const IconThemeData(color: AppColors.vividOrange),

        title: Text("Melodia", style: TextStyle(color: AppColors.vividOrange),).paddingOnly(left: 2.w),
        centerTitle: false,
        toolbarHeight: 10.h,
        actions: [
          IconButton(
              onPressed:() => setState(() {search=true;}), icon:Icon(LucideIcons.search, size: 20,)),
          Icon(Icons.more_vert, size: 25,).paddingOnly(right: 5.w),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
          return ListView.builder(
              itemCount: controller.displayedSongs.length,
              itemBuilder:(context, index){
                 final songs = controller.displayedSongs[index];
                return ListTile(
                  leading:QueryArtworkWidget(
                      id: songs.id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: CircleAvatar(radius:25,backgroundImage:AssetImage("assets/images/note.jpeg"))
                  ),

                  trailing: Icon(Icons.more_vert),
                  title: Text(songs.title,maxLines: 1,overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),

                  subtitle: Text(
                    "${songs.artist} • ${controller.formatDuration(songs.duration!)}",
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                 // onTap: () => controller.playSong(songs.uri!, songs.title),
                  onTap: () {
                    controller.playSong(songs.uri!, songs.title, index);
                  },
                );
              }
          );
        }
      )
    );
  }

}