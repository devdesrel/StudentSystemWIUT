import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/social_search_model.dart';

class SocialSearchBloc {
  String _query;
  int _pageNumber = 1;
  List<SocialSearchModel> searchResultList;
  Future<List<SocialSearchModel>> _getSearchResult(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    String _userTableId = prefs.getString(userTableID);
    int _moduleId = 0;

    List<SocialSearchModel> lists;

    try {
      Response _response = await http.get(
          '$apiSocialSearch/$query/$_userTableId/$_pageNumber/$_moduleId',
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      if (_response.statusCode == 200) {
        final parsed = json.decode(_response.body);

        lists = parsed
            .map<SocialSearchModel>((item) => SocialSearchModel.fromJson(item))
            .toList();
      }
    } catch (e) {
      lists = null;
    }
    return lists;
  }

  Sink<String> get setSearchQuery => _setSearchQueryController.sink;

  final _setSearchQueryController = StreamController<String>();

  Sink<int> get incrementPageNumber => _incrementPageNumberController.sink;

  final _incrementPageNumberController = StreamController<int>();

  Stream<List<SocialSearchModel>> get searchResult =>
      _searchResultSubject.stream;

  final _searchResultSubject = BehaviorSubject<List<SocialSearchModel>>();

  SocialSearchBloc() {
    _setSearchQueryController.stream.listen((query) {
      _query = query;
      _getSearchResult(query).then((result) {
        searchResultList = result;
        _searchResultSubject.add(searchResultList);
      });
    });

    _incrementPageNumberController.stream.listen((val) {
      _pageNumber += val;
      _getSearchResult(_query).then((result) {
        searchResultList != []
            ? searchResultList += result
            : searchResultList = result;
        _searchResultSubject.add(searchResultList);
      });
    });
  }
  dispose() {
    _searchResultSubject.close();
    _setSearchQueryController.close();
    _incrementPageNumberController.close();
  }
}
