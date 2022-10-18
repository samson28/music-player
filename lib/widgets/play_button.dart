import 'package:flutter/material.dart';

Widget playButton(IconData icon, double taille, ActionMusic action) {
  return IconButton(
    onPressed: () {
      switch (action) {
        case ActionMusic.play:
          break;
        case ActionMusic.pause:
          print("Pause");
          break;
        case ActionMusic.rewind:
          print("rewind");
          break;
        case ActionMusic.forward:
          print("forward");
          break;
      }
    },
    icon: Icon(icon),
    iconSize: taille,
  );
}

enum ActionMusic { play, pause, rewind, forward }
