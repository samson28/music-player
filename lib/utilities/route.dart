import 'package:flutter/material.dart';
import 'package:musique_player/screens/play_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const PlayMusique());

      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: const Text("error"),
                    centerTitle: true,
                  ),
                  body: const Center(
                    child: Text("Page Not Found"),
                  ),
                ));
    }
  }
}
