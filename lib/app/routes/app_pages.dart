import 'package:get/get.dart';
import 'package:melodia/app/modules/songs/song_binding.dart';
import 'package:melodia/app/modules/songs/songs_view.dart';

import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';

abstract class AppRoutes {
  static const HOME = '/home';
  static const PLAYER = '/player';
  static const PLAYLIST = '/playlist';
}

class AppPages {
  static final routes = [
    // Page d'accueil
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    /*   GetPage(
      name: AppRoutes.PLAYER,
      page: () => SongView(),
     binding: SongsBinding(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 500),
    ),*/
  ];

  /*  // Lecteur audio (avec arguments)


    // Gestion des playlists
    GetPage(
      name: AppRoutes.PLAYLIST,
      page: () => PlaylistView(),
      binding: PlaylistBinding(),
      transition: Transition.rightToLeft,
    ),
  ];

  // Méthode helper pour la navigation
  static void toPlayer({required Song song}) {
    Get.toNamed(
      AppRoutes.PLAYER,
      arguments: song,
      preventDuplicates: true, // Évite les doublons de route
    );
  }*/
}
