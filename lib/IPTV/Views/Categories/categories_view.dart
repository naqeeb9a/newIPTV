import 'dart:math';

import 'package:bwciptv/IPTV/ViewModel/IPTVModelView/iptv_model_view.dart';
import 'package:bwciptv/IPTV/Views/AllChannels/all_channels.dart';
import 'package:bwciptv/IPTV/Views/DetailPage/detail_page.dart';
import 'package:bwciptv/Widgets/custom_search.dart';
import 'package:bwciptv/Widgets/widget.dart';
import 'package:bwciptv/utils/app_routes.dart';
import 'package:bwciptv/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../Widgets/custom_loader.dart';

class CategoriesListView extends StatefulWidget {
  final TextEditingValue textController;
  const CategoriesListView({Key? key, required this.textController})
      : super(key: key);

  @override
  State<CategoriesListView> createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    controller.value = widget.textController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IPTVModelView iptvModelView = context.watch<IPTVModelView>();
    return Scaffold(
      appBar: BaseAppBar(
          title: "Categories",
          appBar: AppBar(),
          widgets: [
            InkWell(
              onTap: () {
                KRoutes.push(context, const AllChannels());
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                child: const Icon(
                  Icons.search,
                  color: kblack,
                ),
              ),
            ),
          ],
          automaticallyImplyLeading: true,
          appBarHeight: 50),
      body: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
     
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 900) {
                return categoriesView(
                    iptvModelView,
                    context,
                    MediaQuery.of(context).size.width *
                        0.5 /
                        MediaQuery.of(context).size.width *
                        2,
                    6);
              }
              if (constraints.maxWidth > 700) {
                return categoriesView(
                    iptvModelView,
                    context,
                    MediaQuery.of(context).size.width *
                        0.5 /
                        MediaQuery.of(context).size.width *
                        1.7,
                    4);
              }
              if (constraints.maxWidth > 400) {
                return categoriesView(
                    iptvModelView,
                    context,
                    MediaQuery.of(context).size.width *
                        0.5 /
                        MediaQuery.of(context).size.width *
                        1.7,
                    2);
              }
              if (constraints.maxWidth < 350) {
                return categoriesView(
                    iptvModelView,
                    context,
                    MediaQuery.of(context).size.width *
                        0.5 /
                        MediaQuery.of(context).size.width *
                        1,
                    2);
              }

              return categoriesView(iptvModelView, context, 16 / 15, 2);
            },
          ),
        ),
      ),
    );
  }

  Widget categoriesView(IPTVModelView iptvModelView, BuildContext context,
      double aspectRatio, int crossAxisCount) {
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
                color: primaryColor,
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              "assets/emptyList.json",
              width: 200,
            ),
            const CustomText(text: "No Channels found !!"),
          ],
        ),
      );
    }
    List<String> categoriesList = iptvModelView.playList.keys.toList();
    final suggestions = iptvModelView.playList.keys.toList().where((element) {
      final categoryTitle = element.toLowerCase();
      final input = controller.text.toLowerCase();
      return categoryTitle.contains(input);
    }).toList();
    categoriesList = suggestions;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: CustomSearch(
            controller: controller,
            searchText: "Search Categories",
            function: () {
              setState(() {});
            },
            onSubmitted: (value) {
              KRoutes.pop(context);

              KRoutes.push(
                  context,
                  CategoriesListView(
                    textController: TextEditingValue(text: value),
                  ));
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount, childAspectRatio: aspectRatio),
            itemCount: categoriesList.length,
            itemBuilder: (BuildContext context, int index) {
              final value = categoriesList[index];
              return InkWell(
                onTap: () => KRoutes.push(
                    context,
                    Scaffold(
                      appBar: BaseAppBar(
                          title: value == "" ? "Undefined" : value,
                          appBar: AppBar(),
                          automaticallyImplyLeading: true,
                          widgets: const [],
                          appBarHeight: 50),
                      body: DetailPage(
                        playList: iptvModelView.playList[value],
                        textEditingValue: const TextEditingValue(),
                      ),
                    )),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kblack.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: CustomText(
                      text: value == "" ? "Undefined" : value,
                      textAlign: TextAlign.center,
                      fontsize: 20,
                      fontWeight: FontWeight.bold,
                      color: kWhite,
                      maxLines: 5,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
