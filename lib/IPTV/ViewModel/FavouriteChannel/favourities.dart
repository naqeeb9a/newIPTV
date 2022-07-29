import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:m3u_nullsafe/m3u_nullsafe.dart';

class FavouritiesModelView extends ChangeNotifier {
  Map<String, List<M3uGenericEntry>> favouriteList = {};

  addToFavourities(String categoryName, M3uGenericEntry item) {
    if (favouriteList.containsKey(categoryName)) {
      (favouriteList[categoryName] as List).add(item);
    } else {
      favouriteList[categoryName] = [];
      (favouriteList[categoryName] as List).add(item);
    }

    notifyListeners();
  }

  removeFromFavourities(String categoryName, M3uGenericEntry item) {
    (favouriteList[categoryName] as List).remove(item);
    if ((favouriteList[categoryName] as List).isEmpty) {
      favouriteList.remove(categoryName);
    }

    notifyListeners();
  }
}
