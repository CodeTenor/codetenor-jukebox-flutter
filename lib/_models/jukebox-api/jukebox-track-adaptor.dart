import 'package:jukebox_flutter/_models/jukebox-api/jukebox-track.dart';

import '../adaptor.dart';

class JukeboxTrackAdaptor implements Adaptor {
  @override
  adapt(item) {
    return new JukeboxTrack(item['track_id'], item['title'], item['artist'], item['picture_big'], item['played']);
  }
}