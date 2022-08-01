import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bwciptv/Widgets/custom_text.dart';
import 'package:bwciptv/utils/app_routes.dart';
import 'package:bwciptv/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class PlayerScreen extends StatefulWidget {
  final String link;
  final String title;
  const PlayerScreen({Key? key, required this.link, required this.title})
      : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VlcPlayerController _videoPlayerController;
  bool initplayer = false;
  bool isPlaying = false;
  double opacity = 1;

  void checkVideo() {
    setState(() {
      isPlaying = _videoPlayerController.value.isPlaying;
    });
  }

  @override
  void initState() {
    super.initState();
    setSystemPref();
    initPlayer();
  }

  setSystemPref() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  initPlayer() async {
    setState(() {
      initplayer = false;
    });
    _videoPlayerController = VlcPlayerController.network(
      widget.link,
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );

    _videoPlayerController.addListener(checkVideo);
    setState(() {
      initplayer = true;
    });
  }

  @override
  void dispose() async {
    super.dispose();
    if (_videoPlayerController.value.isInitialized) {
      _videoPlayerController.removeListener(checkVideo);
      await _videoPlayerController.stopRendererScanning();
      await _videoPlayerController.dispose();
    }
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  @override
  Widget build(BuildContext context) {
    Orientation deviceState = MediaQuery.of(context).orientation;
    return Scaffold(
        backgroundColor: kblack,
        body: initplayer
            ? Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: Stack(
                  fit: deviceState == Orientation.landscape
                      ? StackFit.expand
                      : StackFit.loose,
                  alignment: Alignment.center,
                  children: [
                    buildVideoPlayer(deviceState),
                    buildHeader(),
                    buildFooter(deviceState),
                    _videoPlayerController.value.bufferPercent > 0
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          )
                        : Container()
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ));
  }

  Widget buildVideoPlayer(Orientation deviceState) {
    return buildFullScreen(
        child: VlcPlayer(
          controller: _videoPlayerController,
          aspectRatio: _videoPlayerController.value.aspectRatio,
        ),
        deviceState: deviceState);
  }

  Widget buildFullScreen(
      {required Widget child, required Orientation deviceState}) {
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        height: deviceState == Orientation.landscape
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height,
        width: deviceState == Orientation.landscape
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width,
        child: child,
      ),
    );
  }

  Widget buildHeader() {
    return Positioned(
      top: 10,
      left: 10,
      right: 10,
      child: AnimatedOpacity(
        duration: const Duration(seconds: 2),
        opacity: opacity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    KRoutes.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: kWhite,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomText(
                  text: widget.title,
                  color: kWhite,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFooter(deviceState) {
    return Positioned(
      bottom: 10,
      left: 10,
      right: 10,
      child: AnimatedOpacity(
        duration: const Duration(seconds: 2),
        opacity: opacity,
        child: Column(
          children: [
            ProgressBar(
              progress: _videoPlayerController.value.position,
              total: _videoPlayerController.value.duration,
              timeLabelTextStyle: const TextStyle(color: kWhite),
              onSeek: (duration) {
                _videoPlayerController.seekTo(duration);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () async {
                          final currentPosition =
                              _videoPlayerController.value.position;
                          _videoPlayerController.seekTo(
                              currentPosition - const Duration(seconds: 5));
                        },
                        child: const Icon(
                          Icons.fast_rewind,
                          color: kWhite,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          isPlaying = _videoPlayerController.value.isPlaying;
                          if (isPlaying == true) {
                            setState(() {
                              isPlaying = true;
                              _videoPlayerController.pause();
                            });
                          } else {
                            setState(() {
                              isPlaying = false;
                              _videoPlayerController.play();
                            });
                          }
                        },
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: kWhite,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final currentPosition =
                            _videoPlayerController.value.position;
                        _videoPlayerController.seekTo(
                            currentPosition + const Duration(seconds: 5));
                      },
                      child: const Icon(
                        Icons.fast_forward,
                        color: kWhite,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                    onTap: () async {
                      if (deviceState == Orientation.portrait) {
                        await SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.immersive);
                        await SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeLeft,
                        ]);
                      } else {
                        await SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                        ]);
                      }
                    },
                    child: const Icon(
                      Icons.fullscreen,
                      color: kWhite,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getFormattedDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
