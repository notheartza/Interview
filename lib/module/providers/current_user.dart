import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:iig_interview/module/models/current_user.dart';
import 'package:provider/provider.dart';
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
    prefs.setString("CurrentUser", user.toJson().toString());
    prefs.setString("token", getToken);
    prefs.setInt("createAt", DateTime.now().microsecondsSinceEpoch);
    prefs.setInt("updateAt", DateTime.now().microsecondsSinceEpoch);
    prefs.setInt("expiredAt",
        DateTime.now().add(const Duration(hours: 2)).microsecondsSinceEpoch);

    //DateTime.fromMillisecondsSinceEpoch((prefs.getInt('yourKey')??DateTime.now().millisecondsSinceEpoch);  ดึง key data มา เป็น datetime
    //print("gettoken=> $getToken");
    /*currentUser = user;
    token = getToken;
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
    expiredAt = DateTime.now().add(const Duration(hours: 2));*/
    notifyListeners();
  }

  updateUser(CurrentUser user) {
    //currentUser = user;
    //updatedAt = DateTime.now();
    notifyListeners();
  }

  updateToken(String getToken) {
    //token = getToken;
    //updatedAt = DateTime.now();
    //expiredAt = DateTime.now().add(const Duration(hours: 2));
  }
}
