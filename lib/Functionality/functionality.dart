// ignore_for_file: depend_on_referenced_packages

import 'package:bwciptv/IPTV/ViewModel/IPTVModelView/iptv_model_view.dart';
import 'package:bwciptv/Widgets/widget.dart';
import 'package:bwciptv/utils/app_routes.dart';
import 'package:bwciptv/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:m3u_nullsafe/m3u_nullsafe.dart';
import '../IPTV/ViewModel/FavouriteChannel/favourities_channel.dart';

class Functionality {
  showDialogueLink(BuildContext context, TextEditingController? controller,
      IPTVModelView iptvModelView) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: "Enter Url",
                      fontsize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FormTextField(
                      controller: controller,
                      suffixIcon: const Icon(Icons.link)),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                      buttonColor: primaryColor,
                      text: "Update Link",
                      textColor: kWhite,
                      function: () {
                        baseUrl = controller!.text;
                        iptvModelView.setModelError(null);
                        iptvModelView.getChannelsList();
                        KRoutes.rootPop(context);
                        Fluttertoast.showToast(msg: "Playlist Loaded");
                      }),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            ));
  }

  showDialogueStorage(BuildContext context, TextEditingController? controller,
      IPTVModelView iptvModelView) {
    showError() {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: CustomText(
        text: "Invalid file, Make sure the file is with m3u extension",
        color: kWhite,
      )));
    }

    popScreens() {
      KRoutes.rootPop(context);
      Fluttertoast.showToast(msg: "PLaylist Loaded");
    }

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Icon(
                    Icons.file_open_outlined,
                    size: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                      buttonColor: primaryColor,
                      text: "Pick File",
                      textColor: kWhite,
                      function: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();

                        if (result != null) {
                          PlatformFile file = result.files.first;
                          if (file.extension == "m3u" ||
                              file.extension == "m3u8") {
                            iptvModelView.setModelError(null);
                            iptvModelView
                                .getChannelsListStorage(file.path.toString());
                            popScreens();
                          } else {
                            showError();
                          }
                        } else {
                          // User canceled the picker
                        }
                      }),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            ));
  }

  showDialogueFav(BuildContext context, TextEditingController? controller,
      M3uGenericEntry? item) {
    Map favList =
        Provider.of<FavouritiesModelView>(context, listen: false).favouriteList;
    return favList.isEmpty
        ? showAddingCategory(context, controller, item)
        : showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(text: "Select a category"),
                      GestureDetector(
                          onTap: () {
                            showAddingCategory(context, controller, item);
                          },
                          child: const Icon(Icons.add))
                    ],
                  ),
                  content: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: kblack.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(20)),
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: CustomText(
                                text:
                                    "${index + 1} - ${favList.keys.toList()[index]}",
                                fontsize: 18,
                              ),
                              onTap: () {
                                Provider.of<FavouritiesModelView>(context,
                                        listen: false)
                                    .addToFavourities(
                                  favList.keys.toList()[index],
                                  item,
                                );
                                KRoutes.pop(context);
                                Fluttertoast.showToast(
                                    msg: "Added to favourites");
                              },
                              enableFeedback: true,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemCount: favList.keys.toList().length)),
                ));
  }

  showAddingCategory(
    BuildContext context,
    TextEditingController? controller,
    M3uGenericEntry? item,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(text: "Add a new category"),
                GestureDetector(
                    onTap: () {
                      KRoutes.pop(context);
                    },
                    child: const Icon(Icons.close))
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: "Category name :",
                    fontsize: 15,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FormTextField(
                    controller: controller, suffixIcon: const Icon(Icons.link)),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                    buttonColor: primaryColor,
                    text: "Add Category",
                    textColor: kWhite,
                    function: () {
                      if (controller!.text.isEmpty) {
                        Fluttertoast.showToast(msg: "Field cannot be empty");
                      } else {
                        Provider.of<FavouritiesModelView>(context,
                                listen: false)
                            .addToFavourities(controller.text, null);
                        KRoutes.rootPop(context);
                        Fluttertoast.showToast(msg: "Category added");
                        controller.text = "";
                      }
                    }),
                const SizedBox(
                  height: 5,
                )
              ],
            ),
          );
        });
  }
}
