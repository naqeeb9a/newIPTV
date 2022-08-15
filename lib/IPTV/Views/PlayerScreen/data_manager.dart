// // ignore_for_file: depend_on_referenced_packages

// import 'dart:async';

// import 'package:flick_video_player/flick_video_player.dart';
// import 'package:m3u_nullsafe/m3u_nullsafe.dart';
// import 'package:video_player/video_player.dart';

// class DataManager {
//   DataManager({required this.flickManager, required this.urls});

//   int currentPlaying = 0;
//   final FlickManager flickManager;
//   final List<M3uGenericEntry?>? urls;

//   late Timer videoChangeTimer;

//   String getNextVideo() {
//     currentPlaying++;
//     return urls![currentPlaying]!.link;
//   }
  

//   bool hasNextVideo() {
//     return currentPlaying != urls!.length - 1;
//   }

//   bool hasPreviousVideo() {
//     return currentPlaying != 0;
//   }

//   skipToNextVideo([Duration? duration]) {
//     if (hasNextVideo()) {
//       flickManager.handleChangeVideo(
//           VideoPlayerController.network(urls![currentPlaying + 1]!.link),
//           videoChangeDuration: duration);

//       currentPlaying++;
//     }
//   }

//   skipToPreviousVideo() {
//     if (hasPreviousVideo()) {
//       currentPlaying--;
//       flickManager.handleChangeVideo(
//           VideoPlayerController.network(urls![currentPlaying]!.link));
//     }
//   }

//   cancelVideoAutoPlayTimer({required bool playNext}) {
//     if (playNext != true) {
//       currentPlaying--;
//     }

//     flickManager.flickVideoManager
//         ?.cancelVideoAutoPlayTimer(playNext: playNext);
//   }
// }
