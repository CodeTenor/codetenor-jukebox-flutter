class CreateJukeboxTrack {
  int track_id;
  String title;
  String artist;
  String picture_big;
  bool played;
  int web_user_id;

  CreateJukeboxTrack(this.track_id, this.title, this.artist, this.picture_big, this.played, this.web_user_id);

  Map<String, dynamic> toJson() =>
    {
      'track_id': track_id,
      'title': title,
      'artist': artist,
      'picture_big': picture_big,
      'played': played,
      'web_user_id': web_user_id
    };
}