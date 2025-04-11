import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodia/app/modules/albums/album_controller.dart';
import 'package:melodia/app/modules/albums/album_view.dart';
import 'package:melodia/app/widgets/player/search_bar.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sizer/sizer.dart';



class AlbumListView extends StatelessWidget {
  const AlbumListView({super.key});

  @override
  Widget build(BuildContext context) {
    final AlbumController controller = Get.find<AlbumController>();
    return Scaffold(
      appBar: CustomSearchBar(search: false,title: "Albums",),
      body: Padding(
        padding: EdgeInsets.only(top: 1.h,left: 2.w, right: 2.w),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 18,mainAxisSpacing: 10),
            itemCount:  controller.albums.length,
            itemBuilder: (context, index) {
              final album = controller.albums.value[index];
              return  GestureDetector(
                onTap: () {
                  Get.to(()=>AlbumView(albumId: album.id,));
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: QueryArtworkWidget(
                        id: album.id,
                        type: ArtworkType.ALBUM,
                        size: 1024,
                        artworkFit: BoxFit.cover,
                        artworkBorder: BorderRadius.circular(10),
                        nullArtworkWidget: Container(
                          color: Colors.grey[800],
                          child: const Icon(Icons.music_note, color: Colors.white, size: 50),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -5,
                      left: -3,
                      right: 10,
                      child: ListTile(
                        title: Text(album.album,maxLines: 1,overflow: TextOverflow.ellipsis,
                            style: TextStyle( color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold,)),
                        subtitle: Text(album.artist!,maxLines: 1,overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.labelSmall,),
                      )
                    ),
                  ],
                ),
              );
        
        
            },),
      )
    );
  }
}
