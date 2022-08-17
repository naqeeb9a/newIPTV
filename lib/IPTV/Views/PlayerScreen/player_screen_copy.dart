import 'package:better_player/better_player.dart';
import 'package:bwciptv/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:m3u_nullsafe/m3u_nullsafe.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key, required this.playList, required this.index})
      : super(key: key);

  final int index;
  final List<M3uGenericEntry?>? playList;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late int basicIndex;
  bool initPlayer = false;
  bool isScreenMounted = true;
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();
    basicIndex = widget.index;
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.playList![basicIndex]!.link,
      cacheConfiguration: const BetterPlayerCacheConfiguration(
        useCache: true,
        preCacheSize: 10 * 1024 * 1024,
        maxCacheSize: 10 * 1024 * 1024,
        maxCacheFileSize: 10 * 1024 * 1024,
      ),
      bufferingConfiguration: const BetterPlayerBufferingConfiguration(
        minBufferMs: 50000,
        maxBufferMs: 13107200,
        bufferForPlaybackMs: 2500,
        bufferForPlaybackAfterRebufferMs: 5000,
      ),
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: widget.playList![basicIndex]!.title,
        imageUrl: widget.playList![basicIndex]!.attributes.keys.toList().isEmpty
            ? "https://cdn.shopify.com/app-store/listing_images/b4e1fa4bf25f6bfb071bfe11a1ce136c/icon/CM37wMP0lu8CEAE=.jpg"
            : widget.playList![basicIndex]!.attributes["tvg-logo"].toString(),
      ),
    );
    _betterPlayerController = BetterPlayerController(
        const BetterPlayerConfiguration(
          autoPlay: true,
          // fullScreenByDefault: true,
          controlsConfiguration: BetterPlayerControlsConfiguration(),
        ),
        betterPlayerDataSource: betterPlayerDataSource);
    _betterPlayerController.setVolume(1);
    if (isScreenMounted) {
      Fluttertoast.showToast(
          msg: "Now Playing ${widget.playList![basicIndex]!.title}");
    }
    setState(() {
      initPlayer = true;
    });
  }

  Future<void> onKey(RawKeyEvent e) async {
    if (e.runtimeType == RawKeyDownEvent) {
      if (e.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
        if (isScreenMounted) {
          backward();
        }
      }
      if (e.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
        if (isScreenMounted) {
          forward();
        }
      }
      if (e.isKeyPressed(LogicalKeyboardKey.select)) {
        setState(() {
          if (_betterPlayerController.videoPlayerController!.value.isPlaying) {
            _betterPlayerController.pause();
          } else {
            _betterPlayerController.play();
          }
        });
      }
      if (e.isKeyPressed(LogicalKeyboardKey.enter)) {
        setState(() {
          if (_betterPlayerController.videoPlayerController!.value.isPlaying) {
            _betterPlayerController.pause();
          } else {
            _betterPlayerController.play();
          }
        });
      }
    }
  }

  forward() {
    _betterPlayerController.dispose();
    setState(() {
      initPlayer = false;
      if ((basicIndex + 1) == widget.playList!.length) {
        basicIndex = 0;
      } else {
        basicIndex = basicIndex + 1;
      }
      BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.playList![basicIndex]!.link,
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: true,
          preCacheSize: 10 * 1024 * 1024,
          maxCacheSize: 10 * 1024 * 1024,
          maxCacheFileSize: 10 * 1024 * 1024,
        ),
        bufferingConfiguration: const BetterPlayerBufferingConfiguration(
          minBufferMs: 50000,
          maxBufferMs: 13107200,
          bufferForPlaybackMs: 2500,
          bufferForPlaybackAfterRebufferMs: 5000,
        ),
        notificationConfiguration: BetterPlayerNotificationConfiguration(
          showNotification: true,
          title: widget.playList![basicIndex]!.title,
          imageUrl: widget.playList![basicIndex]!.attributes.keys
                  .toList()
                  .isEmpty
              ? "https://cdn.shopify.com/app-store/listing_images/b4e1fa4bf25f6bfb071bfe11a1ce136c/icon/CM37wMP0lu8CEAE=.jpg"
              : widget.playList![basicIndex]!.attributes["tvg-logo"].toString(),
        ),
      );
      _betterPlayerController = BetterPlayerController(
          const BetterPlayerConfiguration(
            autoPlay: true,
            controlsConfiguration: BetterPlayerControlsConfiguration(),
          ),
          betterPlayerDataSource: betterPlayerDataSource)
        ..setVolume(1);
    });
    if (isScreenMounted) {
      Fluttertoast.showToast(
          msg: "Now Playing ${widget.playList![basicIndex]!.title}");
    }
    Future.delayed(const Duration(seconds: 2), () {
      if (isScreenMounted) {
        setState(() {
          initPlayer = true;
        });
      }
    });
  }

  backward() {
    _betterPlayerController.dispose();
    setState(() {
      initPlayer = false;
      if (basicIndex == 0) {
        basicIndex = widget.playList!.length - 1;
      } else {
        basicIndex = basicIndex - 1;
      }
      BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.playList![basicIndex]!.link,
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: true,
          preCacheSize: 10 * 1024 * 1024,
          maxCacheSize: 10 * 1024 * 1024,
          maxCacheFileSize: 10 * 1024 * 1024,
        ),
        bufferingConfiguration: const BetterPlayerBufferingConfiguration(
          minBufferMs: 50000,
          maxBufferMs: 13107200,
          bufferForPlaybackMs: 2500,
          bufferForPlaybackAfterRebufferMs: 5000,
        ),
        notificationConfiguration: BetterPlayerNotificationConfiguration(
          showNotification: true,
          title: widget.playList![basicIndex]!.title,
          imageUrl: widget.playList![basicIndex]!.attributes.keys
                  .toList()
                  .isEmpty
              ? "https://cdn.shopify.com/app-store/listing_images/b4e1fa4bf25f6bfb071bfe11a1ce136c/icon/CM37wMP0lu8CEAE=.jpg"
              : widget.playList![basicIndex]!.attributes["tvg-logo"].toString(),
        ),
      );
      _betterPlayerController = BetterPlayerController(
          const BetterPlayerConfiguration(
            autoPlay: true,
            controlsConfiguration: BetterPlayerControlsConfiguration(),
          ),
          betterPlayerDataSource: betterPlayerDataSource)
        ..setVolume(1);
    });
    if (isScreenMounted) {
      Fluttertoast.showToast(
          msg: "Now Playing ${widget.playList![basicIndex]!.title}");
    }
    Future.delayed(const Duration(seconds: 2), () {
      if (isScreenMounted) {
        setState(() {
          initPlayer = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (dragDetail) {
        if (dragDetail.velocity.pixelsPerSecond.dx < -2) {
          if (isScreenMounted) {
            backward();
          }
        } else if (dragDetail.velocity.pixelsPerSecond.dx > 2) {
          if (isScreenMounted) {
            forward();
          }
        }
      },
      child: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: onKey,
        child: Scaffold(
          backgroundColor: kblack,
          body: Center(
            child: initPlayer
                ? AspectRatio(
                    aspectRatio: 16 / 9,
                    child: BetterPlayer(
                      controller: _betterPlayerController,
                    ),
                  )
                : const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    isScreenMounted = false;
    super.dispose();
  }
}
