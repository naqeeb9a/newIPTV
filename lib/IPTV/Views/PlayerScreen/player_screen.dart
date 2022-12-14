// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
// import 'package:bwciptv/Widgets/custom_text.dart';
// import 'package:bwciptv/utils/app_routes.dart';
// import 'package:bwciptv/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// import 'package:m3u_nullsafe/m3u_nullsafe.dart';

// class PlayerScreen extends StatefulWidget {
//   final List<M3uGenericEntry?>? playList;
//   final int index;
//   const PlayerScreen({Key? key, this.playList, required this.index})
//       : super(key: key);

//   @override
//   State<PlayerScreen> createState() => _PlayerScreenState();
// }

// class _PlayerScreenState extends State<PlayerScreen> {
//   late VlcPlayerController _videoPlayerController;
//   bool initplayer = false;
//   bool isPlaying = false;
//   double opacity = 1;
//   bool isMounted = true;
//   bool showLoader = false;
//   bool showError = false;
//   int movieCounter = 0;

//   void checkVideo() {
//     setState(() {
//       isPlaying = _videoPlayerController.value.isPlaying;
//       if (_videoPlayerController.value.playingState == PlayingState.buffering) {
//         showLoader = true;
//       } else {
//         showLoader = false;
//       }
//       if (_videoPlayerController.value.hasError) {
//         showError = true;
//       } else {
//         showError = false;
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     movieCounter = widget.index;
//     setSystemPref();

//     initPlayer();
//   }

//   setSystemPref() async {
//     await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
//   }

//   hideCotrols() {
//     Future.delayed(const Duration(seconds: 5), () {
//       if (isMounted) {
//         setState(() {
//           opacity = 0;
//         });
//       }
//     });
//   }

//   initPlayer() async {
//     setState(() {
//       initplayer = false;
//     });
//     _videoPlayerController = VlcPlayerController.network(
//       widget.playList![widget.index]!.link,
//       hwAcc: HwAcc.full,
//       autoPlay: true,
//       options: VlcPlayerOptions(),
//     );

//     _videoPlayerController.addListener(checkVideo);
//     setState(() {
//       initplayer = true;
//     });
//   }

//   @override
//   void dispose() async {
//     super.dispose();
//     isMounted = false;
//     if (_videoPlayerController.value.isInitialized) {
//       _videoPlayerController.removeListener(checkVideo);
//       await _videoPlayerController.stopRendererScanning();
//       await _videoPlayerController.dispose();
//     }
//     await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//   }

//   @override
//   Widget build(BuildContext context) {
//     Orientation deviceState = MediaQuery.of(context).orientation;
//     return Scaffold(
//         backgroundColor: kblack,
//         body: RawKeyboardListener(
//           autofocus: true,
//           focusNode: FocusNode(),
//           onKey: onKey,
//           child: initplayer
//               ? Container(
//                   height: deviceState == Orientation.landscape
//                       ? MediaQuery.of(context).size.width
//                       : MediaQuery.of(context).size.height,
//                   alignment: Alignment.center,
//                   child: Stack(
//                     fit: deviceState == Orientation.landscape
//                         ? StackFit.expand
//                         : StackFit.loose,
//                     children: [
//                       buildVideoPlayer(deviceState),
//                       buildFooter(deviceState),
//                       _videoPlayerController.value.bufferPercent > 0
//                           ? const Center(
//                               child: CircularProgressIndicator(
//                                 valueColor:
//                                     AlwaysStoppedAnimation<Color>(Colors.blue),
//                               ),
//                             )
//                           : Container()
//                     ],
//                   ),
//                 )
//               : const Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                   ),
//                 ),
//         ));
//   }

//   Widget buildVideoPlayer(Orientation deviceState) {
//     return buildFullScreen(
//         child: VlcPlayer(
//           controller: _videoPlayerController,
//           aspectRatio: _videoPlayerController.value.aspectRatio,
//         ),
//         deviceState: deviceState);
//   }

//   Widget buildFullScreen(
//       {required Widget child, required Orientation deviceState}) {
//     return FittedBox(
//       fit: BoxFit.cover,
//       child: SizedBox(
//         height: deviceState == Orientation.landscape
//             ? MediaQuery.of(context).size.width
//             : MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: child,
//       ),
//     );
//   }

//   Widget buildFooter(deviceState) {
//     return Positioned(
//       bottom: 10,
//       left: 10,
//       top: 10,
//       right: 10,
//       child: AnimatedOpacity(
//         duration: const Duration(milliseconds: 600),
//         opacity: opacity,
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           color: Colors.transparent,
//           child: Column(
//             children: [
//               AnimatedOpacity(
//                 duration: const Duration(seconds: 2),
//                 opacity: opacity,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             KRoutes.pop(context);
//                           },
//                           child: const Icon(
//                             Icons.arrow_back_ios,
//                             color: kWhite,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         CustomText(
//                           text: widget.playList![movieCounter]!.title,
//                           color: kWhite,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                   child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           if (opacity == 0) {
//                             opacity = 1;
//                             hideCotrols();
//                           } else {
//                             opacity = 0;
//                           }
//                         });
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         color: Colors.transparent,
//                         child: showError
//                             ? const CustomText(
//                                 text: "Invalid link",
//                                 color: kWhite,
//                               )
//                             : showLoader
//                                 ? const CircularProgressIndicator()
//                                 : null,
//                       ))),
//               Column(
//                 children: [
//                   ProgressBar(
//                     progress: _videoPlayerController.value.position,
//                     total: _videoPlayerController.value.duration,
//                     timeLabelTextStyle: const TextStyle(color: kWhite),
//                     onSeek: (duration) {
//                       _videoPlayerController.seekTo(duration);
//                     },
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           GestureDetector(
//                               onTap: () async {
//                                 _videoPlayerController.stop();
//                                 _videoPlayerController
//                                     .removeListener(checkVideo);
//                                 movieCounter--;
//                                 setState(() {
//                                   initplayer = false;
//                                 });
//                                 await Future.delayed(const Duration(seconds: 5),
//                                     () {
//                                   _videoPlayerController =
//                                       VlcPlayerController.network(
//                                     widget.playList![movieCounter]!.link,
//                                     hwAcc: HwAcc.full,
//                                     autoPlay: true,
//                                     options: VlcPlayerOptions(),
//                                   );
//                                 });

//                                 _videoPlayerController.addListener(checkVideo);
//                                 setState(() {
//                                   initplayer = true;
//                                 });
//                               },
//                               child: const Icon(
//                                 Icons.fast_rewind,
//                                 color: kWhite,
//                               )),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           GestureDetector(
//                               onTap: () {
//                                 isPlaying =
//                                     _videoPlayerController.value.isPlaying;
//                                 if (isPlaying == true) {
//                                   setState(() {
//                                     isPlaying = true;
//                                     _videoPlayerController.pause();
//                                   });
//                                 } else {
//                                   setState(() {
//                                     isPlaying = false;
//                                     _videoPlayerController.play();
//                                   });
//                                 }
//                               },
//                               child: Icon(
//                                 isPlaying ? Icons.pause : Icons.play_arrow,
//                                 color: kWhite,
//                               )),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           GestureDetector(
//                             onTap: () async {
//                               _videoPlayerController.stop();
//                               _videoPlayerController.removeListener(checkVideo);
//                               movieCounter++;
//                               setState(() {
//                                 initplayer = false;
//                               });
//                               await Future.delayed(const Duration(seconds: 2),
//                                   () {
//                                 _videoPlayerController =
//                                     VlcPlayerController.network(
//                                   widget.playList![movieCounter]!.link,
//                                   hwAcc: HwAcc.full,
//                                   autoPlay: true,
//                                   options: VlcPlayerOptions(),
//                                 );
//                               });

//                               _videoPlayerController.addListener(checkVideo);
//                               setState(() {
//                                 initplayer = true;
//                               });
//                             },
//                             child: const Icon(
//                               Icons.fast_forward,
//                               color: kWhite,
//                             ),
//                           ),
//                         ],
//                       ),
//                       GestureDetector(
//                           onTap: () async {
//                             if (deviceState == Orientation.portrait) {
//                               await SystemChrome.setEnabledSystemUIMode(
//                                   SystemUiMode.immersive);
//                               await SystemChrome.setPreferredOrientations([
//                                 DeviceOrientation.landscapeLeft,
//                               ]);
//                             } else {
//                               await SystemChrome.setPreferredOrientations([
//                                 DeviceOrientation.portraitUp,
//                               ]);
//                             }
//                           },
//                           child: const Icon(
//                             Icons.fullscreen,
//                             color: kWhite,
//                           ))
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String getFormattedDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }

  
// }
