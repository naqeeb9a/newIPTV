import 'package:better_player/better_player.dart';
import 'package:bwciptv/utils/utils.dart';
import 'package:flutter/material.dart';

class PlayerScreen extends StatelessWidget {
  final String link;
  const PlayerScreen({Key? key, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kblack,
      body: SafeArea(
        child: BetterPlayer.network(
          link,
          betterPlayerConfiguration: const BetterPlayerConfiguration(
              fullScreenByDefault: true,
              aspectRatio: 16 / 9,
              autoPlay: true,
              controlsConfiguration: BetterPlayerControlsConfiguration(
                  enableProgressBar: false,
                  enableProgressText: false,
                  enableSkips: false)),
        ),
      ),
    );
  }
}
