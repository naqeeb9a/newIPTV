// // ignore_for_file: depend_on_referenced_packages

// import 'package:better_player/better_player.dart';
// import 'package:bwciptv/Widgets/custom_app_bar.dart';
// import 'package:bwciptv/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:line_icons/line_icons.dart';

// import 'package:m3u_nullsafe/m3u_nullsafe.dart';

// class PlayerScreen extends StatefulWidget {
//   final List<M3uGenericEntry?>? playList;
//   final int index;
//   const PlayerScreen({Key? key, required this.playList, required this.index})
//       : super(key: key);

//   @override
//   State<PlayerScreen> createState() => _PlayerScreenState();
// }

// class _PlayerScreenState extends State<PlayerScreen> {
//   late BetterPlayerController _betterPlayerController;
//   late int basicIndex;
//   @override
//   void initState() {
//     super.initState();
//     basicIndex = widget.index;
//     BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
//       BetterPlayerDataSourceType.network,
//       widget.playList![basicIndex]!.link,
//       cacheConfiguration: const BetterPlayerCacheConfiguration(
//         useCache: true,
//         preCacheSize: 10 * 1024 * 1024,
//         maxCacheSize: 10 * 1024 * 1024,
//         maxCacheFileSize: 10 * 1024 * 1024,
//       ),
//       bufferingConfiguration: const BetterPlayerBufferingConfiguration(
//         minBufferMs: 50000,
//         maxBufferMs: 13107200,
//         bufferForPlaybackMs: 2500,
//         bufferForPlaybackAfterRebufferMs: 5000,
//       ),
//       notificationConfiguration: BetterPlayerNotificationConfiguration(
//         showNotification: true,
//         title: widget.playList![basicIndex]!.title,
//         imageUrl: widget.playList![basicIndex]!.attributes.keys.toList().isEmpty
//             ? "https://cdn.shopify.com/app-store/listing_images/b4e1fa4bf25f6bfb071bfe11a1ce136c/icon/CM37wMP0lu8CEAE=.jpg"
//             : widget.playList![basicIndex]!.attributes["tvg-logo"].toString(),
//       ),
//     );
//     _betterPlayerController = BetterPlayerController(
//         const BetterPlayerConfiguration(
//           controlsConfiguration: BetterPlayerControlsConfiguration(),
//         ),
//         betterPlayerDataSource: betterPlayerDataSource);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kblack,
//       appBar: BaseAppBar(
//           title: widget.playList![basicIndex]!.title,
//           appBar: AppBar(),
//           widgets: [
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if ((basicIndex + 1) == widget.playList!.length) {
//                     basicIndex = 0;
//                   } else {
//                     basicIndex = basicIndex + 1;
//                   }
//                   BetterPlayerDataSource betterPlayerDataSource =
//                       BetterPlayerDataSource(
//                     BetterPlayerDataSourceType.network,
//                     widget.playList![basicIndex]!.link,
//                     cacheConfiguration: const BetterPlayerCacheConfiguration(
//                       useCache: true,
//                       preCacheSize: 10 * 1024 * 1024,
//                       maxCacheSize: 10 * 1024 * 1024,
//                       maxCacheFileSize: 10 * 1024 * 1024,
//                     ),
//                     bufferingConfiguration:
//                         const BetterPlayerBufferingConfiguration(
//                       minBufferMs: 50000,
//                       maxBufferMs: 13107200,
//                       bufferForPlaybackMs: 2500,
//                       bufferForPlaybackAfterRebufferMs: 5000,
//                     ),
//                     notificationConfiguration:
//                         BetterPlayerNotificationConfiguration(
//                       showNotification: true,
//                       title: widget.playList![basicIndex]!.title,
//                       imageUrl: widget.playList![basicIndex]!.attributes.keys
//                               .toList()
//                               .isEmpty
//                           ? "https://cdn.shopify.com/app-store/listing_images/b4e1fa4bf25f6bfb071bfe11a1ce136c/icon/CM37wMP0lu8CEAE=.jpg"
//                           : widget.playList![basicIndex]!.attributes["tvg-logo"]
//                               .toString(),
//                     ),
//                   );
//                   _betterPlayerController = BetterPlayerController(
//                       const BetterPlayerConfiguration(
//                         controlsConfiguration:
//                             BetterPlayerControlsConfiguration(),
//                       ),
//                       betterPlayerDataSource: betterPlayerDataSource);
//                 });
//               },
//               child: Container(
//                 padding: const EdgeInsets.only(right: 20),
//                 child: const Icon(
//                   LineIcons.backward,
//                   color: kWhite,
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if ((basicIndex - 1) == widget.playList!.length) {
//                     basicIndex = 0;
//                   } else {
//                     basicIndex = basicIndex - 1;
//                   }
//                   BetterPlayerDataSource betterPlayerDataSource =
//                       BetterPlayerDataSource(
//                     BetterPlayerDataSourceType.network,
//                     widget.playList![basicIndex]!.link,
//                     cacheConfiguration: const BetterPlayerCacheConfiguration(
//                       useCache: true,
//                       preCacheSize: 10 * 1024 * 1024,
//                       maxCacheSize: 10 * 1024 * 1024,
//                       maxCacheFileSize: 10 * 1024 * 1024,
//                     ),
//                     bufferingConfiguration:
//                         const BetterPlayerBufferingConfiguration(
//                       minBufferMs: 50000,
//                       maxBufferMs: 13107200,
//                       bufferForPlaybackMs: 2500,
//                       bufferForPlaybackAfterRebufferMs: 5000,
//                     ),
//                     notificationConfiguration:
//                         BetterPlayerNotificationConfiguration(
//                       showNotification: true,
//                       title: widget.playList![basicIndex]!.title,
//                       imageUrl: widget.playList![basicIndex]!.attributes.keys
//                               .toList()
//                               .isEmpty
//                           ? "https://cdn.shopify.com/app-store/listing_images/b4e1fa4bf25f6bfb071bfe11a1ce136c/icon/CM37wMP0lu8CEAE=.jpg"
//                           : widget.playList![basicIndex]!.attributes["tvg-logo"]
//                               .toString(),
//                     ),
//                   );
//                   _betterPlayerController = BetterPlayerController(
//                       const BetterPlayerConfiguration(
//                         controlsConfiguration:
//                             BetterPlayerControlsConfiguration(),
//                       ),
//                       betterPlayerDataSource: betterPlayerDataSource);
//                 });
//               },
//               child: Container(
//                 padding: const EdgeInsets.only(right: 20, left: 20),
//                 child: const Icon(
//                   LineIcons.forward,
//                   color: kWhite,
//                 ),
//               ),
//             )
//           ],
//           automaticallyImplyLeading: true,
//           textColor: kWhite,
//           centerTitle: false,
//           appBarHeight: 50),
//       body: Center(
//         child: AspectRatio(
//           aspectRatio: 16 / 9,
//           child: BetterPlayer(
//             controller: _betterPlayerController,
//           ),
//         ),
//       ),
//     );
//   }
// }
