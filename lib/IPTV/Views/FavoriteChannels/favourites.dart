// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:bwciptv/Functionality/functionality.dart';
import 'package:bwciptv/IPTV/ViewModel/FavouriteChannel/favourities_channel.dart';
import 'package:bwciptv/IPTV/Views/AllChannels/all_channels.dart';
import 'package:bwciptv/IPTV/Views/Categories/categories_view.dart';
import 'package:bwciptv/IPTV/Views/DetailPage/detail_page.dart';
import 'package:bwciptv/Widgets/widget.dart';
import 'package:bwciptv/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:m3u_nullsafe/m3u_nullsafe.dart';

import '../../../utils/utils.dart';
import '../Drawer/drawer.dart';

class Favourities extends StatefulWidget {
  const Favourities({Key? key}) : super(key: key);

  @override
  State<Favourities> createState() => _FavouritiesState();
}

final GlobalKey<ScaffoldState> _key = GlobalKey();

class _FavouritiesState extends State<Favourities> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Map<String, List<M3uGenericEntry?>> favList =
        context.watch<FavouritiesModelView>().favouriteList;
    return Scaffold(
      key: _key,
      appBar: BaseAppBar(
          title: "Favourites",
          leading: InkWell(
              onTap: () {
                _key.currentState!.openDrawer();
              },
              child: const Icon(
                Icons.menu,
                color: kblack,
              )),
          automaticallyImplyLeading: true,
          appBar: AppBar(),
          widgets: [
            InkWell(
              onTap: () {
                KRoutes.push(
                    context,
                    const CategoriesListView(
                      textController: TextEditingValue(),
                    ));
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                child: const Icon(
                  LineIcons.television,
                  color: kblack,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                KRoutes.push(context, const AllChannels());
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                child: const Icon(
                  LineIcons.search,
                  color: kblack,
                ),
              ),
            ),
          ],
          appBarHeight: 50),
      drawer: const Drawer(child: CustomDrawer()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Functionality().showAddingCategory(
            context,
            controller,
            null,
          );
        },
        child: const Icon(Icons.add),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 900) {
            return favouritesView(
                favList,
                MediaQuery.of(context).size.width *
                    0.5 /
                    MediaQuery.of(context).size.width *
                    2,
                6);
          }
          if (constraints.maxWidth > 600) {
            return favouritesView(
                favList,
                MediaQuery.of(context).size.width *
                    0.5 /
                    MediaQuery.of(context).size.width *
                    1.5,
                5);
          }
          if (constraints.maxWidth < 350) {
            return favouritesView(
                favList,
                MediaQuery.of(context).size.width *
                    0.5 /
                    MediaQuery.of(context).size.width *
                    1,
                2);
          }

          return favouritesView(favList, 16 / 20, 3);
        },
      ),
    );
  }

  Widget favouritesView(Map<String, List<M3uGenericEntry?>> favList,
      double aspectRatio, int crossAxisCount) {
    if (favList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              "assets/emptyList.json",
              width: 200,
            ),
            const SizedBox(
              height: 10,
            ),
            const CustomText(text: "No favourites"),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: aspectRatio,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemCount: favList.keys.toList().length,
      itemBuilder: (BuildContext context, int index) {
        final changedColor =
            Colors.primaries[Random().nextInt(Colors.primaries.length)];
        final updatedValue = favList.keys.toList()[index];
        return InkWell(
          onTap: () {
            KRoutes.push(
                context,
                Scaffold(
                    appBar: BaseAppBar(
                        title: updatedValue,
                        appBar: AppBar(),
                        automaticallyImplyLeading: true,
                        widgets: const [],
                        appBarHeight: 50),
                    body: DetailPage(
                      playList: favList[updatedValue],
                      isFav: true,
                      textEditingValue: const TextEditingValue(),
                    )));
          },
          onLongPress: () {
            Widget cancelButton = TextButton(
              child: const Text("Yes"),
              onPressed: () {
                KRoutes.rootPop(context);
                context
                    .read<FavouritiesModelView>()
                    .removeCategoryFromFavourities(updatedValue);
              },
            );
            Widget continueButton = TextButton(
              child: const Text("No"),
              onPressed: () {},
            );
            AlertDialog alert = AlertDialog(
              title: const Text("Delete"),
              content: const Text("Would you like to delete this category?"),
              actions: [
                cancelButton,
                continueButton,
              ],
            );
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                ShaderMask(
                  shaderCallback: (bound) {
                    return LinearGradient(
                        end: FractionalOffset.topCenter,
                        begin: FractionalOffset.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.99),
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                        stops: const [
                          0.0,
                          0.3,
                          0.45
                        ]).createShader(bound);
                  },
                  blendMode: BlendMode.srcOver,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: changedColor),
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                Positioned(
                    bottom: 20,
                    left: 10,
                    right: 10,
                    child: CustomText(
                      text: updatedValue,
                      fontsize: 30,
                      color: kWhite,
                      textAlign: TextAlign.center,
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
