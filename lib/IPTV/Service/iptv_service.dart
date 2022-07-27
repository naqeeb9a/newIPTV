import 'dart:io';

import 'package:bwciptv/IPTV/Service/api_status.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:m3u_nullsafe/m3u_nullsafe.dart';

class IPTVService {
  static getChannels() async {
    try {
      Uri url = Uri.parse("https://iptv-org.github.io/iptv/countries/pk.m3u");
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        return Success(200, await yieldCategories(response.body));
      }
      return Failure(response.statusCode, "Invalid Response");
    } on HttpException {
      return Failure(101, "No internet");
    } on FormatException {
      return Failure(102, "Invalid format");
    } catch (e) {
      return Failure(103, "Unknown Error");
    }
  }

  static Future<Map<String, List<M3uGenericEntry>>> yieldCategories(
      String file) async {
    final playlist = await M3uParser.parse(file);
    final categories =
        sortedCategories(entries: playlist, attributeName: 'group-title');
    return categories;
  }
}
