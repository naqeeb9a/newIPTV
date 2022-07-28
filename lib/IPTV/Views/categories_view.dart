import 'package:bwciptv/IPTV/ViewModel/iptv_model_view.dart';
import 'package:bwciptv/IPTV/Views/detail_page.dart';
import 'package:bwciptv/IPTV/Views/drawer.dart';
import 'package:bwciptv/Widgets/custom_text.dart';
import 'package:bwciptv/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_loader.dart';

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
                  Row(
                    children: const [
                      Icon(
                        CupertinoIcons.heart,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  )
                ],
                appBarHeight: 50),
            drawer: const Drawer(
              child: CustomDrawer(),
            ),
            body: categoriesView(iptvModelView)));
  }

  Widget categoriesView(IPTVModelView iptvModelView) {
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
      return CustomText(
          text: iptvModelView.modelError!.errorResponse.toString());
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
    List<Tab> tabs = [];
    for (String element in iptvModelView.playList.keys.toList()) {
      tabs.add(Tab(
        child: CustomText(
          text: element,
          color: kWhite,
        ),
      ));
    }
    return DefaultTabController(
      length: iptvModelView.playList.keys.toList().length,
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
              children: iptvModelView.playList.keys
                  .toList()
                  .map((value) =>
                      DetailPage(playList: iptvModelView.playList[value]))
                  .toList())),
    );
  }
}
