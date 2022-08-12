// ignore_for_file: depend_on_referenced_packages

import 'package:bwciptv/IPTV/Views/PlayerScreen/controls.dart';
import 'package:bwciptv/Widgets/custom_app_bar.dart';
import 'package:bwciptv/Widgets/custom_text.dart';
import 'package:bwciptv/utils/app_routes.dart';
import 'package:bwciptv/utils/utils.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';
import 'package:m3u_nullsafe/m3u_nullsafe.dart';
import 'data_manager.dart';

class CustomOrientationPlayer extends StatefulWidget {
  final List<M3uGenericEntry?>? playList;
  final int index;
  const CustomOrientationPlayer(
      {Key? key, required this.playList, required this.index})
      : super(key: key);

  @override
  State<CustomOrientationPlayer> createState() =>
      _CustomOrientationPlayerState();
}

class _CustomOrientationPlayerState extends State<CustomOrientationPlayer> {
  late FlickManager flickManager;
  late DataManager dataManager;

  @override
  void initState() {
    super.initState();

    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(
            widget.playList![widget.index]!.link,
            videoPlayerOptions:
                VideoPlayerOptions(allowBackgroundPlayback: true)),
        onVideoEnd: () {
          dataManager.skipToNextVideo(const Duration(seconds: 5));
        });

    dataManager =
        DataManager(flickManager: flickManager, urls: widget.playList);
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  skipToVideo(String url) {
    flickManager.handleChangeVideo(VideoPlayerController.network(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "",
        appBar: AppBar(),
        widgets: const [],
        automaticallyImplyLeading: true,
        appBarHeight: 50,
        textColor: kWhite,
      ),
      endDrawerEnableOpenDragGesture: false,
      endDrawer: Drawer(
        child: ListView.builder(
            itemCount: widget.playList!.length,
            itemBuilder: (context, index) {
              M3uGenericEntry? entry = widget.playList![index];
              return ListTile(
                leading: CircleAvatar(
                  foregroundImage:
                      NetworkImage(entry!.attributes["tvg-logo"].toString()),
                ),
                title: CustomText(text: entry.title),
                onTap: () {
                  KRoutes.pop(context);
                  flickManager.handleChangeVideo(
                      VideoPlayerController.network(entry.link));
                },
              );
            }),
      ),
      backgroundColor: kblack,
      body: VisibilityDetector(
        key: ObjectKey(flickManager),
        onVisibilityChanged: (visibility) {
          if (visibility.visibleFraction == 0 && mounted) {
            flickManager.flickControlManager?.autoPause();
          } else if (visibility.visibleFraction == 1) {
            flickManager.flickControlManager?.autoResume();
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 200,
              child: FlickVideoPlayer(
                flickManager: flickManager,
                preferredDeviceOrientationFullscreen: const [
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ],
                flickVideoWithControls: FlickVideoWithControls(
                  controls: CustomOrientationControls(dataManager: dataManager),
                ),
                flickVideoWithControlsFullscreen: FlickVideoWithControls(
                  videoFit: BoxFit.fitWidth,
                  controls: CustomOrientationControls(dataManager: dataManager),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
