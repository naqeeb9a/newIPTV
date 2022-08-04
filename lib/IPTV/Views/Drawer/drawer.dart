import 'package:bwciptv/Functionality/functionality.dart';
import 'package:bwciptv/IPTV/ViewModel/IPTVModelView/iptv_model_view.dart';
import 'package:bwciptv/Widgets/custom_text.dart';

import 'package:bwciptv/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {

  const CustomDrawer({Key? key,}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    IPTVModelView iptvModelView=context.watch<IPTVModelView>();
    List settings = [
      {
        "name": "List channels from Link",
        "icon": const Icon(Icons.link),
        "function": () {
          Functionality()
              .showDialogueLink(context, controller, iptvModelView);
        }
      },
      {
        "name": "List channels from Storage",
        "icon": const Icon(Icons.link),
        "function": () {
          Functionality()
              .showDialogueStorage(context, controller, iptvModelView);
        }
      },
      {
        "name": "Rate Us",
        "icon": const Icon(Icons.rate_review),
      },
      {
        "name": "About",
        "icon": const Icon(Icons.contact_support),
      },
    ];
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          padding: const EdgeInsets.all(50),
          color: primaryColor,
          child: Image.asset("assets/tv.png"),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemCount: settings.length,
            itemBuilder: (BuildContext context, int index) {
              var newSettings = settings[index];
              return ListTile(
                title: CustomText(text: newSettings["name"]),
                trailing: newSettings["icon"],
                onTap: newSettings["function"],
              );
            },
          ),
        ),
      ],
    );
  }
}
