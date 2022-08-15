import 'package:bwciptv/IPTV/Views/DetailPage/detail_page.dart';
import 'package:bwciptv/Widgets/custom_loader.dart';
import 'package:bwciptv/Widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../utils/utils.dart';
import '../../ViewModel/IPTVModelView/iptv_model_view.dart';

class AllChannels extends StatelessWidget {
  const AllChannels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IPTVModelView iptvModelView = context.watch<IPTVModelView>();
    return Scaffold(
      body: allChannelsView(iptvModelView),
    );
  }

  Widget allChannelsView(IPTVModelView iptvModelView) {
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
    if (iptvModelView.allPlayList.isEmpty) {
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
    return DetailPage(
      playList: iptvModelView.allPlayList,
    );
  }
}
