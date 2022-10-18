import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musique_player/musique.dart';
import 'package:musique_player/widgets/text_style.dart';

class PlayMusique extends StatefulWidget {
  const PlayMusique({super.key});

  @override
  State<PlayMusique> createState() => _PlayMusiqueState();
}

class _PlayMusiqueState extends State<PlayMusique> {
  List<Musique> musiques = [
    Musique(
        title: "musique1",
        artiste: "artiste1",
        imagepath: "assets/disque.png",
        urlSong: "Carte_aux_Adieux.mp3"),
    Musique(
        title: "musique2",
        artiste: "artiste2",
        imagepath: "assets/man.jpg",
        urlSong: "Vertu.mp3")
  ];

  static late AudioPlayer player;
  late StreamSubscription positionSubscription;
  late StreamSubscription stateSubscription;
  static late Musique musiqueActuelle;
  Duration position = const Duration(seconds: 0);
  Duration? duree = const Duration(seconds: 0);
  PlayerState status = PlayerState.stopped;
  int index = 0;

  playerConfiguration() {
    player = AudioPlayer();
    positionSubscription = player.onPositionChanged.listen((pos) {
      if (pos != const Duration(seconds: 0) && pos == duree) {
        player.stop();
        playerConfiguration();
      } else {
        setState(() {
          position = pos;
        });
      }
    });
    stateSubscription = player.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        setState(() async {
          duree = await player.getDuration();
        });
      } else if (state == PlayerState.stopped) {
        setState(() {
          status = PlayerState.stopped;
        });
      }
    }, onError: (message) {
      print('message: $message');
      setState(() {
        status = PlayerState.stopped;
        duree = const Duration(seconds: 0);
        position = const Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    AssetSource source = AssetSource(musiqueActuelle.urlSong);
    await player.play(source);
    Duration? dure = await player.getDuration();
    setState(() {
      status = PlayerState.playing;
      duree = dure;
    });
  }

  Future pause() async {
    await player.pause();
    setState(() {
      status = PlayerState.paused;
    });
  }

  void forward() {
    if (index == musiques.length - 1) {
      index = 0;
    } else {
      index++;
    }

    musiqueActuelle = musiques[index];

    player.stop();
    playerConfiguration();
    play();
  }

  void rewind() {
    if (position > const Duration(seconds: 3)) {
      player.seek(const Duration(seconds: 0));
    } else {
      if (index == 0) {
        index = musiques.length - 1;
      } else {
        index--;
      }
      musiqueActuelle = musiques[index];
      player.stop();
      playerConfiguration();
      play();
    }
  }

  String fromDuration(Duration duree) {
    return duree.toString().split('.').first;
  }

  @override
  void initState() {
    super.initState();
    musiqueActuelle = musiques[index];
    playerConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Musique Player"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                elevation: 9.0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.height / 2.5,
                  child: Image.asset(musiqueActuelle.imagepath),
                ),
              ),
              textStyle(musiqueActuelle.title, 1.5),
              textStyle(musiqueActuelle.artiste, 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  playButton(Icons.fast_rewind, 30.0, ActionMusic.rewind),
                  playButton(
                      (status == PlayerState.playing)
                          ? Icons.pause
                          : Icons.play_arrow,
                      35.0,
                      (status == PlayerState.playing)
                          ? ActionMusic.pause
                          : ActionMusic.play),
                  playButton(Icons.fast_forward, 30.0, ActionMusic.forward)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  textStyle(fromDuration(position), 0.8),
                  textStyle(fromDuration(duree!), 0.8),
                ],
              ),
              Slider(
                  value: position.inSeconds.toDouble(),
                  min: 0,
                  max: duree!.inSeconds.toDouble(),
                  onChanged: (double d) {
                    setState(() {
                      // position = Duration(seconds: d.toInt());
                      player.seek(Duration(seconds: d.toInt()));
                    });
                  })
            ]),
      ),
    );
  }

  Widget playButton(IconData icon, double taille, ActionMusic action) {
    return IconButton(
      onPressed: () {
        switch (action) {
          case ActionMusic.play:
            play();
            break;
          case ActionMusic.pause:
            pause();
            break;
          case ActionMusic.rewind:
            rewind();
            break;
          case ActionMusic.forward:
            forward();
            break;
        }
      },
      icon: Icon(icon),
      iconSize: taille,
    );
  }
}

enum ActionMusic { play, pause, rewind, forward }

enum PlayerState { playing, stopped, paused }
