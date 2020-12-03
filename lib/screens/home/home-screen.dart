import 'package:flutter/material.dart';
import 'package:jukebox_flutter/_models/deezer-api/deezer-artist/deezer-artist.dart';
import 'package:jukebox_flutter/_models/deezer-api/deezer-track/deezer-track.dart';
import 'package:jukebox_flutter/_models/jukebox-api/jukebox-track-adaptor.dart';
import 'package:jukebox_flutter/_models/jukebox-api/jukebox-track.dart';
import 'package:jukebox_flutter/_services/jukebox-api/jukebox-api-service.dart';
import 'package:jukebox_flutter/global/themes/color-themes.dart';
import 'package:jukebox_flutter/screens/home/background/home-screen-background.dart';
import 'package:jukebox_flutter/screens/search/search-screen.dart';

JukeboxApiService jukeboxApiService = JukeboxApiService.internal();
JukeboxTrackAdaptor jukeboxTrackAdaptor = JukeboxTrackAdaptor();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var jukeboxTracks = List<JukeboxTrack>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
        },
        backgroundColor: ColorThemes.background,
        child: Icon(
          Icons.search,
          color: ColorThemes.text,
        ),
      ),
      backgroundColor: ColorThemes.backgroundTertiary,
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            child: CustomPaint(
              size: MediaQuery.of(context).size,
              painter: HomeScreenBackground(),
            ),
          ),
          Column(
            children: <Widget>[
              logo(),
              currentPlaylist(width),
              FutureBuilder(
                builder: (context, projectSnap) {
                  if (projectSnap.connectionState == ConnectionState.none &&
                      projectSnap.hasData == null) {
                    //print('project snapshot data is: ${projectSnap.data}');
                    return Container();
                  }
                  return Expanded(
                    child: SizedBox(
                      height: 200.0,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: getTracks(),
                      ),
                    ),
                  );
                },
                future: getCurerntPlaylist(),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget logo() {
    return Padding(
      padding: EdgeInsets.only(left: 60, top: 80),
      child: Row(
        children: [
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/assets/images/play.png'),
                    fit: BoxFit.fill)),
          ),
          Text('JUKEBOX',
              style: TextStyle(
                  fontSize: 50, color: ColorThemes.text, fontFamily: 'Roboto'))
        ],
      ),
    );
  }

  Widget currentPlaylist(double width) {
    return Padding(
      padding: EdgeInsets.only(top: 40.0, bottom: 20),
      child: Container(
        width: width * 0.7,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: ColorThemes.text, width: 1.0),
            color: ColorThemes.backgroundSecondary),
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Center(
            child: Row(
              children: [
                Expanded(child: Divider()),
                Text('CURRENT PLAYLIST',
                    style: TextStyle(
                        fontSize: 20,
                        color: ColorThemes.text,
                        fontFamily: 'Roboto')),
                Expanded(child: Divider()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getTracks() {
    List<JukeboxTrack> jukeboxTracks = this.jukeboxTracks;
    List<Widget> trackWidget = [];
    for (JukeboxTrack track in jukeboxTracks) {
      trackWidget.add(trackCard(track));
    }
    return trackWidget;
  }

  Widget trackCard(JukeboxTrack track) {
    return Stack(
      children: <Widget>[
        InkWell(
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                new BoxShadow(
                  color: ColorThemes.text,
                  blurRadius: 1.0,
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(track.pictureBig)),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(track.title,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: ColorThemes.background,
                                fontFamily: 'Roboto')),
                        Text(track.artist,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                                color: ColorThemes.background,
                                fontFamily: 'Roboto'))
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getCurerntPlaylist() async {
    await jukeboxApiService.getTracks().then((dynamic response) async {
      jukeboxTracks = List<JukeboxTrack>.from(
          response.map((data) => jukeboxTrackAdaptor.adapt(data))).toList();
    });
  }
}
