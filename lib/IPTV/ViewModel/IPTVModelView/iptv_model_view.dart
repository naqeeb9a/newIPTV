import 'package:bwciptv/IPTV/Model/model_error.dart';
import 'package:bwciptv/IPTV/Service/api_status.dart';
import 'package:bwciptv/IPTV/Service/iptv_service.dart';
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:m3u_nullsafe/m3u_nullsafe.dart';

class IPTVModelView extends ChangeNotifier {
  Map<String, List<M3uGenericEntry>> _playList = {};
  List<M3uGenericEntry> _allPlayList = [];
  bool _loading = false;
  ModelError? _modelError;

  IPTVModelView() {
    getChannelsList();
  }

  Map<String, List<M3uGenericEntry>> get playList => _playList;
  bool get loading => _loading;
  List<M3uGenericEntry> get allPlayList => _allPlayList;
  ModelError? get modelError => _modelError;

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  setPostModelList(List playList) {
    _playList = playList[0] as Map<String, List<M3uGenericEntry>>;
    _allPlayList = playList[1] as List<M3uGenericEntry>;
  }

  setModelError(ModelError? modelError) {
    _modelError = modelError;
  }

  getChannelsList() async {
    setLoading(true);
    var response = await IPTVService.getChannels();
    if (response is Success) {
      setPostModelList(response.response as List);
    }
    if (response is Failure) {
      ModelError modelError = ModelError(response.code, response.errorResponse);
      setModelError(modelError);
    }
    setLoading(false);
  }

  getChannelsListStorage(String path) async {
    setLoading(true);
    var response = await IPTVService.getChannelsStorage(path);
    if (response is Success) {
      setPostModelList(response.response as List);
    }
    if (response is Failure) {
      ModelError modelError = ModelError(102, "Invalid M3u File");
      setModelError(modelError);
    }
    setLoading(false);
  }
}
