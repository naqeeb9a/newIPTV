// ignore_for_file: depend_on_referenced_packages

import 'package:bwciptv/IPTV/Views/player_screen.dart';
import 'package:bwciptv/Widgets/widget.dart';
import 'package:bwciptv/utils/app_routes.dart';
import 'package:bwciptv/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:m3u_nullsafe/m3u_nullsafe.dart';

class DetailPage extends StatelessWidget {
  final List<M3uGenericEntry>? playList;
  const DetailPage({Key? key, required this.playList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.blue, body: chanelsListView());
  }

  Widget chanelsListView() {
    if (playList!.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset("assets/emptyList.json"),
          const CustomText(text: "No channels found")
        ],
      );
    }
    return Container(
      decoration:
          BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        itemCount: playList!.length,
        itemBuilder: (BuildContext context, int index) {
          M3uGenericEntry value = playList![index];
          return InkWell(
            onTap: () {
              KRoutes.push(context, PlayerScreen(link: value.link));
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kWhite,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(1, 2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            color: kGrey)
                      ]),
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  child: Image.network(
                    value.attributes.keys.toList().isEmpty
                        ? "http://"
                        : value.attributes[
                                value.attributes.keys.toList().elementAt(1)]
                            .toString(),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const CircularProgressIndicator();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const CustomText(
                        text: "Unable to load Image",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        fontsize: 10,
                      );
                    },
                    width: 100,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: value.title == "" ? "Unknown Channel" : value.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 16 / 25,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20),
      ),
    );
  }
}
