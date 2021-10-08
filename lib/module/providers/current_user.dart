import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:iig_interview/module/models/current_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentUserProvince extends ChangeNotifier {
  /*CurrentUser? currentUser;
  String? token;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? expiredAt;*/

  CurrentUserProvince(
      /*this.currentUser,
      this.token = '',
      this.createdAt,
      this.updatedAt,
      this.expiredAt*/
      );

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString("token") ?? "");
  }

  setUser(CurrentUser user, String getToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("CurrentUser", jsonEncode(user));
    prefs.setString("token", getToken);
    prefs.setInt("createAt", DateTime.now().microsecondsSinceEpoch);
    prefs.setInt("updateAt", DateTime.now().microsecondsSinceEpoch);
    prefs.setInt("expiredAt",
        DateTime.now().add(const Duration(hours: 2)).microsecondsSinceEpoch);
    notifyListeners();
  }

  logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  updateUser(CurrentUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("CurrentUser", jsonEncode(user));
    prefs.setInt("updateAt", DateTime.now().microsecondsSinceEpoch);
    notifyListeners();
  }

  updateToken(String getToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", getToken);
    prefs.setInt("updateAt", DateTime.now().microsecondsSinceEpoch);
    prefs.setInt("expiredAt",
        DateTime.now().add(const Duration(hours: 2)).microsecondsSinceEpoch);
  }
}
