import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:iig_interview/module/models/current_user.dart';
import 'package:iig_interview/module/models/status_api.dart';
import 'package:iig_interview/module/models/status_api_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserStore {
  Future<StatusAPIMap> signup(CurrentUser user, String password);
  Future<StatusAPIMap> login(username, password);
  Future<StatusAPI> resetpassword(oldpass, newpass);
  Future<StatusAPIMap> getuser();
  Future<StatusAPI> refreshToken();
  Future<StatusAPIMap> updateUser(CurrentUser user);
  Future<StatusAPI> logout();
}

class User implements UserStore {
  var url = "https://backend.notheart.xyz";
  var header = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  @override
  Future<StatusAPIMap> login(username, password) async {
    http.Response response = await http.post(Uri.parse('$url/users/login'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: jsonEncode({"username": username, "password": password}));
    return StatusAPIMap.fromJson(jsonDecode(response.body));
  }

  @override
  Future<StatusAPI> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    http.Response response = await http.get(
      Uri.parse('$url/users/logout'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );
    return StatusAPI.fromJson(jsonDecode(response.body));
  }

  @override
  Future<StatusAPI> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    http.Response response = await http.get(
      Uri.parse('$url/users/refreshToken'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );
    return StatusAPI.fromJson(jsonDecode(response.body));
  }

  @override
  Future<StatusAPIMap> signup(CurrentUser user, String password) async {
    http.Response response = await http.post(Uri.parse('$url/users/signup'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: jsonEncode({
          "username": user.username,
          "password": password,
          "firstName": user.firstName,
          "lastName": user.lastName,
          "image": user.image,
          "email": user.email
        }));
    return StatusAPIMap.fromJson(jsonDecode(response.body));
  }

  @override
  Future<StatusAPIMap> updateUser(CurrentUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    http.Response response = await http.post(
        Uri.parse('$url/users/update/user'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode({
          "firstName": user.firstName,
          "lastName": user.lastName,
          "image": user.image,
          "email": user.email
        }));
    return StatusAPIMap.fromJson(jsonDecode(response.body));
  }

  @override
  Future<StatusAPIMap> getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    http.Response response = await http.get(
      Uri.parse('$url/users/getuser'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );
    return StatusAPIMap.fromJson(jsonDecode(response.body));
  }

  @override
  Future<StatusAPI> resetpassword(oldpass, newpass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    http.Response response =
        await http.post(Uri.parse('$url/users/resetpassword'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token'
            },
            body: jsonEncode({
              "oldPassword": oldpass,
              "newPassword": newpass,
            }));
    var get = jsonDecode(response.body);
    if (get["message"].runtimeType == Map) {
      get["message"] = jsonEncode(get["message"]);
    }
    return StatusAPI.fromJson(get);
  }
}
