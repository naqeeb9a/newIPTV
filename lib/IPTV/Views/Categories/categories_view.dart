import 'package:bwciptv/IPTV/ViewModel/IPTVModelView/iptv_model_view.dart';
import 'package:bwciptv/IPTV/Views/DetailPage/detail_page.dart';
import 'package:bwciptv/IPTV/Views/Drawer/drawer.dart';
import 'package:bwciptv/IPTV/Views/FavoriteChannels/favourites.dart';
import 'package:bwciptv/Widgets/widget.dart';
import 'package:bwciptv/utils/app_routes.dart';
import 'package:bwciptv/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../Widgets/custom_loader.dart';

final GlobalKey<ScaffoldState> _key = GlobalKey();

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IPTVModelView iptvModelView = context.watch<IPTVModelView>();
    return SafeArea(
        child: Scaffold(
            key: _key,
            drawerEnableOpenDragGesture: false,
            appBar: BaseAppBar(
                title: "IPTV",
                appBar: AppBar(),
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: const Icon(
                    CupertinoIcons.line_horizontal_3,
                  ),
                  onPressed: () => _key.currentState!.openDrawer(),
                ),
                widgets: [
                  GestureDetector(
                    onTap: () {
                      KRoutes.push(context, const Favourities());
                    },
                    child: Row(
                      children: const [
                        Icon(
                          CupertinoIcons.heart,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  )
                ],
                appBarHeight: 50),
            drawer: Drawer(
              child: CustomDrawer(
                iptvModelView: iptvModelView,
              ),
            ),
            body: categoriesView(iptvModelView, context)));
  }

  Widget categoriesView(IPTVModelView iptvModelView, BuildContext context) {
    if (iptvModelView.loading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomLoader(),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CustomText(text: "Loading channels  "),
              JumpingDots(
                color: Colors.orange,
                radius: 5,
                innerPadding: 2,
                numberOfDots: 4,
              ),
            ],
          )
        ],
      );
    }
    if (iptvModelView.modelError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              "assets/error.json",
              width: 300,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomText(
              text: iptvModelView.modelError!.errorResponse.toString(),
              fontsize: 15,
            ),
            const SizedBox(
              height: 5,
            ),
            const CustomText(
              text: "Check the link or try again",
              fontsize: 15,
            ),
            const SizedBox(
              height: 40,
            ),
            CustomButton(
              buttonColor: primaryColor,
              text: "Try again",
              fontsize: 18,
              function: () {
                iptvModelView.setModelError(null);
                iptvModelView.getChannelsList();
              },
              textColor: kWhite,
            )
          ],
        ),
      );
    }
    if (iptvModelView.playList.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            "assets/emptyList.json",
            width: 200,
          ),
          const CustomText(text: "No Channels found !!"),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
          children: iptvModelView.playList.keys
              .toList()
              .map((value) => ListTile(
                    title: CustomText(
                      text: value == "" ? "Undefined" : value,
                      fontsize: 15,
                    ),
                    onTap: () => KRoutes.push(
                        context,
                        DetailPage(
                          playList: iptvModelView.playList[value],
                          categoryName: value,
                        )),
                  ))
              .toList()),
    );
  }
}
