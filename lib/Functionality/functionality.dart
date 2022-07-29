import 'package:bwciptv/IPTV/ViewModel/IPTVModelView/iptv_model_view.dart';
import 'package:bwciptv/Widgets/widget.dart';
import 'package:bwciptv/utils/app_routes.dart';
import 'package:bwciptv/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
                        KRoutes.pop(context);
                        KRoutes.pop(context);
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
      KRoutes.pop(context);
      KRoutes.pop(context);
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
}
