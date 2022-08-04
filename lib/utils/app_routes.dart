import 'package:flutter/material.dart';

class KRoutes {
  static push(context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  static pop(context) {
    Navigator.pop(context);
  }

  static rootPop(context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static pushAndRemoveUntil(context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => page,
        ),
        (Route<dynamic> route) => false);
  }

  static popUntil(context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
