// ignore_for_file: depend_on_referenced_packages

import 'package:bwciptv/Functionality/functionality.dart';
import 'package:bwciptv/IPTV/ViewModel/FavouriteChannel/favourities_channel.dart';
import 'package:bwciptv/IPTV/Views/PlayerScreen/custom_orientation_player.dart';
import 'package:bwciptv/Widgets/custom_search.dart';
import 'package:bwciptv/Widgets/widget.dart';
import 'package:bwciptv/utils/app_routes.dart';
import 'package:bwciptv/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:m3u_nullsafe/m3u_nullsafe.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class DetailPage extends StatefulWidget {
  final List<M3uGenericEntry?>? playList;
  final bool isAllChannel;
  const DetailPage(
      {Key? key, required this.playList, this.isAllChannel = false})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController catController = TextEditingController();
  @override
  void initState() {
    Wakelock.enable();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    catController.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
          title: "All channels",
          appBar: AppBar(),
          automaticallyImplyLeading: widget.isAllChannel ? false : true,
          widgets: const [],
          appBarHeight: 50),
      body: SafeArea(
        child: LayoutBuilder(
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
                  3);
            }

            return chanelsListView(context, 16 / 25, 3);
          },
        ),
      ),
    );
  }

  Widget chanelsListView(
      BuildContext context, double aspectRatio, int crossAxisCount) {
    Map<String, List<M3uGenericEntry?>> favList =
        context.watch<FavouritiesModelView>().favouriteList;
    if (widget.playList!.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset("assets/emptyList.json"),
          const CustomText(text: "No channels found")
        ],
      );
    }
    List<M3uGenericEntry?>? channelsList = widget.playList!;
    final suggestions = widget.playList!.where((element) {
      final categoryTitle = element!.title.toLowerCase();
      final input = controller.text.toLowerCase();
      return categoryTitle.contains(input);
    }).toList();
    channelsList = suggestions;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: CustomSearch(
            controller: controller,
            searchText: "Search Channels",
            function: () {
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: channelsList.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (BuildContext context, int index) {
              M3uGenericEntry? value = channelsList![index];
              bool containsValue = false;
              for (List<M3uGenericEntry?> element in favList.values) {
                for (var element2 in element) {
                  final value1 = element2!.title.toLowerCase();
                  final value2 = value!.title.toLowerCase();
                  if (value1 == value2) {
                    containsValue = true;
                  }
                }
              }
              return InkWell(
                onTap: () {
                  KRoutes.push(
                      globalContext,
                      CustomOrientationPlayer(
                        playList: channelsList,
                        index: index,
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
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.01),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.2,
                      child: Image.network(
                        value!.attributes.keys.toList().isEmpty
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
                            if (containsValue) {
                              context
                                  .read<FavouritiesModelView>()
                                  .removeFromFavourities(value);
                              Fluttertoast.showToast(
                                  msg: "Removed from Favouritites");
                            } else {
                              Functionality().showDialogueFav(
                                  context, catController, value);
                            }
                          },
                          child: Icon(
                            containsValue
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: containsValue ? Colors.red : kblack,
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
        ),
      ],
    );
  }
}
