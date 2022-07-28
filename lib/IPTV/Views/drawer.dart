import 'package:bwciptv/Widgets/custom_text.dart';
import 'package:bwciptv/utils/data.dart';
import 'package:bwciptv/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              );
            },
          ),
        ),
      ],
    );
  }
}
