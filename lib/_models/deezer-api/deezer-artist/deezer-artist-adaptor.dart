import '../../adaptor.dart';
import 'deezer-artist.dart';

class DeezerArtistAdaptor implements Adaptor {
  @override
  adapt(item) {
    return new DeezerArtist(item['id'], item['name'], item['picture_big']);
  }
}