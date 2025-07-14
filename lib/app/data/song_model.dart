class Music {
  final String title;
  final String artist;
  final String path; // Chemin du fichier audio
  final int duration; // Durée en secondes

  Music(
      {required this.title,
      required this.artist,
      required this.path,
      required this.duration});
}
