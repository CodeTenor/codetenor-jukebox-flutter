import 'package:jukebox_flutter/_models/jukebox-api/create-jukebox-track.dart';
import 'package:jukebox_flutter/_models/jukebox-api/jukebox-track-adaptor.dart';
import 'package:jukebox_flutter/_services/jukebox-api/jukebox-api-constants.dart';
import 'package:jukebox_flutter/environments/environment.dart';

import '../base-api-service.dart';

class JukeboxApiService {
  // Singleton
  static JukeboxApiService _instance = new JukeboxApiService.internal();
  JukeboxApiService.internal();
  factory JukeboxApiService() => _instance;

  BaseApiService baseApiService = BaseApiService();
  JukeboxTrackAdaptor jukeboxTrackAdaptor = JukeboxTrackAdaptor();

  String jukeboxApiUrl = environment['jukeboxApiUrl'];

  Future<dynamic> getTracks() async {
    String getTracks = this.jukeboxApiUrl + get_tracks;

    return await baseApiService
        .getResponse(getTracks);
  }

  Future<dynamic> postTrack(CreateJukeboxTrack track) async {
    String getTracks = this.jukeboxApiUrl + get_tracks;

    return await baseApiService
        .post(track.toJson(), getTracks, false);
  }
}