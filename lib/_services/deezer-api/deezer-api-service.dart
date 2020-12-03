import 'package:jukebox_flutter/_models/deezer-api/deezer-track/deezer-track-adaptor.dart';
import 'package:jukebox_flutter/_models/deezer-api/deezer-track/deezer-track.dart';
import 'package:jukebox_flutter/_services/deezer-api/deezer-api-constants.dart';
import 'package:jukebox_flutter/environments/environment.dart';

import '../base-api-service.dart';

class DeezerApiService {
  // Singleton
  static DeezerApiService _instance = new DeezerApiService.internal();
  DeezerApiService.internal();
  factory DeezerApiService() => _instance;

  BaseApiService baseApiService = BaseApiService();
  DeezerTrackAdaptor deezerTrackAdaptor = DeezerTrackAdaptor();

  String deezerApiUrl = environment['deezerApiUrl'];

  Future<dynamic> searchDeezer(String searchPhrase) async {
    String search = this.deezerApiUrl + deezer_search + searchPhrase;

    return await baseApiService
        .getResponse(search);
  }
}