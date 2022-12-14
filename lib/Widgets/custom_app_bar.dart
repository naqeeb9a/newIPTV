import 'package:flutter/material.dart';
import 'package:bwciptv/utils/utils.dart';

import '../utils/app_routes.dart';

class BaseAppBar extends StatelessWidget with PreferredSizeWidget {
  final Color backgroundColor;
  final Color textColor;
  final String title;
  final AppBar appBar;
  final bool automaticallyImplyLeading, centerTitle;
  final List<Widget> widgets;
  final double appBarHeight;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  /// you can add more fields that meet your needs

  const BaseAppBar(
      {Key? key,
      required this.title,
      required this.appBar,
      required this.widgets,
      this.automaticallyImplyLeading = false,
      this.backgroundColor = Colors.transparent,
      this.centerTitle = true,
      drawerEnableOpenDragGesture = false,
      required this.appBarHeight,
      this.bottom,
      this.leading,
      this.textColor = kblack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: true,
      leading: automaticallyImplyLeading == false
          ? null
          : leading ??
              InkWell(
                onTap: () => KRoutes.pop(context),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                  color: textColor,
                ),
              ),
      actions: widgets,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
