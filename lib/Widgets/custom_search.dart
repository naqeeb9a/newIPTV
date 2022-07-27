import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bwciptv/utils/utils.dart';

class CustomSearch extends StatelessWidget {
  final bool enabled;
  final TextEditingController? controller;
  final dynamic function;
  const CustomSearch(
      {Key? key, this.enabled = true, this.controller, this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: kGrey.withOpacity(0.3))),
      child: Row(
        children: [
          const Icon(CupertinoIcons.search),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: TextField(
            enabled: enabled,
            controller: controller,
            decoration: const InputDecoration(
                hintText: "Search anything", border: InputBorder.none),
            onSubmitted: (value) async {
              await function();
            },
          ))
        ],
      ),
    );
  }
}
