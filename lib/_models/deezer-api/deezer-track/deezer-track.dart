import 'package:jukebox_flutter/_models/deezer-api/deezer-artist/deezer-artist.dart';

class DeezerTrack {
  int id;
  String title;
  DeezerArtist artist;

  DeezerTrack(this.id, this.title, this.artist);
}