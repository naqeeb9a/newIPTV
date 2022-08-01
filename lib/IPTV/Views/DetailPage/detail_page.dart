// ignore_for_file: depend_on_referenced_packages

import 'package:bwciptv/IPTV/ViewModel/FavouriteChannel/favourities.dart';
import 'package:bwciptv/IPTV/Views/PlayerScreem/player_screen.dart';
import 'package:bwciptv/Widgets/widget.dart';
import 'package:bwciptv/utils/app_routes.dart';
import 'package:bwciptv/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:m3u_nullsafe/m3u_nullsafe.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  final List<M3uGenericEntry>? playList;
  final String categoryName;
  const DetailPage(
      {Key? key, required this.playList, required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: BaseAppBar(
        title: "Catalogue",
        appBar: AppBar(),
        widgets: const [],
        appBarHeight: 50,
        automaticallyImplyLeading: true,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 900) {
            return chanelsListView(
                context,
                MediaQuery.of(context).size.width *
                    0.5 /
                    MediaQuery.of(context).size.width *
                    1,
                6);
          }
          if (constraints.maxWidth > 600) {
            return chanelsListView(
                context,
                MediaQuery.of(context).size.width *
                    0.5 /
                    MediaQuery.of(context).size.width *
                    1,
                5);
          }
          if (constraints.maxWidth < 350) {
            return chanelsListView(
                context,
                MediaQuery.of(context).size.width *
                    0.5 /
                    MediaQuery.of(context).size.width *
                    1,
                2);
          }

          return chanelsListView(context, 16 / 25, 3);
        },
      ),
    );
  }

  Widget chanelsListView(
      BuildContext context, double aspectRatio, int crossAxisCount) {
    Map favList = Provider.of<FavouritiesModelView>(context).favouriteList;
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
        padding: const EdgeInsets.all(5),
        itemBuilder: (BuildContext context, int index) {
          M3uGenericEntry value = playList![index];

          return InkWell(
            onTap: () {
              KRoutes.push(
                  context,
                  PlayerScreen(
                    link: value.link,
                    title: value.title == ""
                        ? "Unknown Channel ${index + 1}"
                        : value.title,
                  ));
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
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.2,
                  child: Image.network(
                    value.attributes.keys.toList().isEmpty
                        ? "http://"
                        : value.attributes["tvg-logo"].toString(),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const CircularProgressIndicator();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("assets/tvPlaceHolder.png");
                    },
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text: value.title == ""
                            ? "Unknown Channel ${index + 1}"
                            : value.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (favList[categoryName] != null &&
                            (favList[categoryName] as List).contains(value)) {
                          Provider.of<FavouritiesModelView>(context,
                                  listen: false)
                              .removeFromFavourities(categoryName, value);
                        } else {
                          Provider.of<FavouritiesModelView>(context,
                                  listen: false)
                              .addToFavourities(categoryName, value);
                        }
                      },
                      child: Icon(
                        favList[categoryName] != null &&
                                (favList[categoryName] as List).contains(value)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: favList[categoryName] != null &&
                                (favList[categoryName] as List).contains(value)
                            ? Colors.red
                            : kblack,
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20),
      ),
    );
  }
}
