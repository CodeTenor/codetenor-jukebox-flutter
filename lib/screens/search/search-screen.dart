import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jukebox_flutter/_models/deezer-api/deezer-track/deezer-track-adaptor.dart';
import 'package:jukebox_flutter/_models/deezer-api/deezer-track/deezer-track.dart';
import 'package:jukebox_flutter/_models/jukebox-api/create-jukebox-track.dart';
import 'package:jukebox_flutter/_models/jukebox-api/jukebox-track.dart';
import 'package:jukebox_flutter/_services/deezer-api/deezer-api-service.dart';
import 'package:jukebox_flutter/_services/jukebox-api/jukebox-api-service.dart';
import 'package:jukebox_flutter/global/themes/color-themes.dart';
import 'package:jukebox_flutter/screens/home/home-screen.dart';

DeezerApiService deezerApiService = DeezerApiService.internal();
DeezerTrackAdaptor deezerTrackAdaptor = DeezerTrackAdaptor();
JukeboxApiService jukeboxApiService = JukeboxApiService.internal();

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var deezerTracks = List<DeezerTrack>();

  final searchPhraseController = TextEditingController();
  var searching = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorThemes.background,
      body: Stack(
        children: [
          Column(
            children: [
              logo(),
              search(width),
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Divider(color: ColorThemes.text),
              ),
              Expanded(
                  child: SizedBox(
                height: 200.0,
                child: searching == true
                    ? ListView(
                        scrollDirection: Axis.vertical,
                        children: getTracks(),
                      )
                    : Container(),
              ))
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

  Widget search(double width) {
    return Padding(
        padding: EdgeInsets.only(top: 40.0, bottom: 20),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 65.0),
              child: Container(
                width: width * 0.5,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: searchPhraseController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      filled: true,
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                          color: ColorThemes.text,
                          fontFamily: 'Roboto'),
                      hintText: "Search Track",
                      fillColor: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Container(
                  width: width * 0.15,
                  height: width * 0.15,
                  child: RaisedButton(
                    shape: CircleBorder(
                        side: BorderSide(
                            width: 1,
                            color: ColorThemes.text,
                            style: BorderStyle.solid)),
                    onPressed: () {
                      this.searchDeezer();
                    },
                    child: Icon(
                      Icons.search,
                      color: ColorThemes.text,
                    ),
                  )),
            )
          ],
        ));
  }

  List<Widget> getTracks() {
    List<DeezerTrack> deezerTracks = this.deezerTracks;
    List<Widget> trackWidget = [];
    for (DeezerTrack deezerTrack in deezerTracks) {
      trackWidget.add(trackCard(deezerTrack));
    }
    return trackWidget;
  }

  Widget trackCard(DeezerTrack track) {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            addToPlaylist(track);
          },
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
                              image: NetworkImage(track.artist.artwork)),
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
                        Text(track.artist.name,
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

  searchDeezer() async {
    await deezerApiService
        .searchDeezer(this.searchPhraseController.text)
        .then((dynamic response) async {
      deezerTracks = List<DeezerTrack>.from(
              response['data'].map((data) => deezerTrackAdaptor.adapt(data)))
          .toList();
      setState(() {
        this.searching = true;
      });
    });
  }

  addToPlaylist(DeezerTrack track) async {
    await jukeboxApiService
        .postTrack(new CreateJukeboxTrack(track.id, track.title,
            track.artist.name, track.artist.artwork, false, 1))
        .then((dynamic response) async {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new HomeScreen()),
      );
    });
  }
}
