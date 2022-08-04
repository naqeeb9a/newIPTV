import 'dart:convert';

import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:m3u_nullsafe/m3u_nullsafe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritiesModelView extends ChangeNotifier {
  Map<String, List<M3uGenericEntry?>> favouriteList = {};
  FavouritiesModelView() {
    assignFavList();
  }

  addToFavourities(String categoryName, M3uGenericEntry? item) async {
    SharedPreferences favList = await SharedPreferences.getInstance();
    if (favouriteList.containsKey(categoryName)) {
      if (item != null) {
        (favouriteList[categoryName] as List).add(item);
      }
    } else {
      favouriteList[categoryName] = <M3uGenericEntry?>[];
      if (item != null) {
        (favouriteList[categoryName] as List).add(item);
      }
    }
    Map<String, List<Map>> sortedData = {};
    for (var element in favouriteList.keys) {
      sortedData[element] =
          ((favouriteList[element] as List<M3uGenericEntry?>).map((e) {
        return {"title": e!.title, "attributes": e.attributes, "link": e.link};
      })).toList();
    }
    favList.setString("favList", jsonEncode(sortedData));

    notifyListeners();
  }

  assignFavList() async {
    SharedPreferences favList = await SharedPreferences.getInstance();
    var getList = favList.getString("favList");
    if (getList != null) {
      Map<String, dynamic> extractedData = jsonDecode(getList);
      Map<String, List<M3uGenericEntry?>> sortedData = {};
      for (var element in extractedData.keys) {
        sortedData[element] = ((extractedData[element] as List).map((e) {
          Map<String, dynamic> sortedAttributes = e["attributes"];
          Map<String, String?> updatedAttributes = {};
          for (var element2 in sortedAttributes.keys) {
            updatedAttributes[element2] = sortedAttributes[element2] as String?;
          }
          return M3uGenericEntry(
              attributes: updatedAttributes,
              title: e["title"],
              link: e["link"]);
        })).toList();
      }
      favouriteList = sortedData;
    }
    notifyListeners();
  }

  removeFromFavourities(M3uGenericEntry item) async {
    SharedPreferences favList = await SharedPreferences.getInstance();
    for (List<M3uGenericEntry?> element in favouriteList.values) {
      for (var i = 0; i < element.length; i++) {
        final value1 = element[i]!.title.toLowerCase();
        final value2 = item.title.toLowerCase();
        if (value1 == value2) {
          element.removeAt(i);
        }
      }
    }
    Map<String, List<Map>> sortedData = {};
    for (var element in favouriteList.keys) {
      sortedData[element] =
          ((favouriteList[element] as List<M3uGenericEntry?>).map((e) {
        return {"title": e!.title, "attributes": e.attributes, "link": e.link};
      })).toList();
    }
    favList.setString("favList", jsonEncode(sortedData));
    notifyListeners();
  }

  removeCategoryFromFavourities(String key) {
    favouriteList.remove(key);
    notifyListeners();
  }
}
