import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodia/app/modules/playlist/playList_controller.dart';
import 'package:melodia/app/theme/color.dart';
import 'package:melodia/app/widgets/player/search_bar.dart';
import 'package:sizer/sizer.dart';

class PlaylistView extends StatelessWidget {
  const PlaylistView({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaylistController playlistController = Get.find<PlaylistController>();

    return Scaffold(
      appBar: CustomSearchBar(search: false, title: "Playlist"),
      body: Obx(() {
        if (playlistController.playlists.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: playlistController.playlists.length,
          itemBuilder: (context, index) {
            final playList = playlistController.playlists[index];
            return ListTile(
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage("assets/images/test.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              trailing: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: AppColors.blanc),
                onSelected: (String value) {
                  switch (value) {
                    case 'view':
                      print("View songs");
                      break;
                    case 'rename':
                      _showPopup(
                        currentName: playList.playlist,
                        onSubmit: (newName) => playlistController.renamePlayList(playList.id, newName),
                      );

                      break;
                    case 'add':
                      print("Add song to playlist");
                      break;
                    case 'delete':
                      showDeleteConfirmation(onConfirm: () => playlistController.removePlaylist(playList.id, playList.playlist));
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(value: 'view', child: Text('View songs')),
                  PopupMenuItem(value: 'rename', child: Text('Rename')),
                  PopupMenuItem(value: 'add', child: Text('Add song')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
              title: Text(
                playList.playlist,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                playList.numOfSongs != 0 ? "${playList.numOfSongs} song(s)" : "Empty",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ).paddingOnly(top: 2.h);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPopup(
          onSubmit: (name) => playlistController.createPlayList(name),
        ),
        child: Icon(Icons.add, color: AppColors.blanc, size: 25),
      ).paddingOnly(bottom: 15.h),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
void _showPopup({
  String? currentName,
  required Function(String) onSubmit,
}) {
  final TextEditingController _controller = TextEditingController(text: currentName ?? "");

  Get.dialog<String>(
    AlertDialog(
      title: Text(currentName == null ? "New playlist" : "Rename playlist"),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(hintText: "Playlist name"),
        controller: _controller,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final text = _controller.text.trim();
            if (text.isNotEmpty) {
              Get.back(result: text);
            }
          },
          child: Text(currentName == null ? 'Add' : 'Rename'),
        ),
      ],
    ),
  ).then((value) {

    if (value != null && value.isNotEmpty) {
      onSubmit(value);
      print('Typed text: $value');
    }
  });
}
void showDeleteConfirmation({
  required VoidCallback onConfirm,
}) {
  Get.dialog(
    AlertDialog(
      title: Text("Confirm Delete"),
      content: Text("Are you sure you want to delete this playlist?"),
      actions: [
        TextButton(
          onPressed: () => Get.back(), 
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Get.back(); 
            onConfirm();
          },
          child: Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}


