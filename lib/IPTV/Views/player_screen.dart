import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class PlayerScreen extends StatelessWidget {
  final String link;
  const PlayerScreen({Key? key, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(link);
    return Scaffold(
      body: SafeArea(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer.network(
            link,
            betterPlayerConfiguration: const BetterPlayerConfiguration(
                aspectRatio: 16 / 9,
                autoPlay: true,
                controlsConfiguration: BetterPlayerControlsConfiguration(
                    enableProgressBar: false,
                    enableProgressText: true,
                    enableSkips: false)),
          ),
        ),
      ),
    );
  }
}
