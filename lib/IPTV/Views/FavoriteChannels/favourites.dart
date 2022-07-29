// ignore_for_file: depend_on_referenced_packages

import 'package:bwciptv/IPTV/ViewModel/FavouriteChannel/favourities.dart';
import 'package:bwciptv/IPTV/Views/DetailPage/detail_page.dart';
import 'package:bwciptv/Widgets/widget.dart';
import 'package:bwciptv/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:m3u_nullsafe/m3u_nullsafe.dart';

class Favourities extends StatelessWidget {
  const Favourities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, List<M3uGenericEntry>> favList =
        context.read<FavouritiesModelView>().favouriteList;
    if (favList.isEmpty) {
      return Scaffold(
        appBar: BaseAppBar(
          title: "Favourites",
          appBar: AppBar(),
          automaticallyImplyLeading: true,
          appBarHeight: 50,
          widgets: const [],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset("assets/emptyList.json"),
              const SizedBox(
                height: 10,
              ),
              const CustomText(text: "No favourites"),
            ],
          ),
        ),
      );
    }
    List<Tab> tabs = [];
    for (String element in favList.keys.toList()) {
      tabs.add(Tab(
        child: CustomText(
          text: element,
          color: kWhite,
        ),
      ));
    }
    return Scaffold(
      appBar: BaseAppBar(
        title: "Favourites",
        appBar: AppBar(),
        automaticallyImplyLeading: true,
        appBarHeight: 50,
        widgets: const [],
      ),
      body: DefaultTabController(
        length: favList.keys.toList().length,
        child: Scaffold(
            appBar: BaseAppBar(
              title: "",
              appBar: AppBar(),
              widgets: const [],
              appBarHeight: 70,
              bottom: TabBar(
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: tabs,
              ),
            ),
            body: TabBarView(
                children: favList.keys
                    .toList()
                    .map((value) => DetailPage(
                          playList: (favList[value] as List<M3uGenericEntry>),
                          categoryName: value,
                        ))
                    .toList())),
      ),
    );
  }
}
