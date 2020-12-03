import 'package:jukebox_flutter/_models/deezer-api/deezer-artist/deezer-artist-adaptor.dart';

import '../../adaptor.dart';
import 'deezer-track.dart';

class DeezerTrackAdaptor implements Adaptor {
  DeezerArtistAdaptor deezerArtistAdaptor = DeezerArtistAdaptor();
  @override
  adapt(item) {
    return new DeezerTrack(item['id'], item['title_short'], deezerArtistAdaptor.adapt(item['artist']));
  }
}