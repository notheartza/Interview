import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:iig_interview/module/models/current_user.dart';

class CurrentUserProvince with ChangeNotifier, DiagnosticableTreeMixin {
  CurrentUser? currentUser;
  String? token;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? expiredAt;

  CurrentUserProvince(
      {this.currentUser, this.token, this.createdAt, this.updatedAt});

  setUser(CurrentUser user, String getToken) {
    currentUser = user;
    token = getToken;
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
    expiredAt = DateTime.now().add(const Duration(hours: 2));
    notifyListeners();
  }

  updateUser(CurrentUser user) {
    currentUser = user;
    updatedAt = DateTime.now();
    notifyListeners();
  }

  updateToken(String getToken) {
    token = getToken;
    updatedAt = DateTime.now();
    expiredAt = DateTime.now().add(const Duration(hours: 2));
  }
}
