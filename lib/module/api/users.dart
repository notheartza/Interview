import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:iig_interview/module/models/current_user.dart';
import 'package:iig_interview/module/models/status_api.dart';
import 'package:iig_interview/module/models/status_api_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserStore {
  Future<StatusAPIMap> signup(CurrentUser user);
  Future<StatusAPIMap> login(username, password);
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
  Future<StatusAPIMap> signup(CurrentUser user) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<StatusAPIMap> updateUser(CurrentUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    //print(get);
    http.Response response = await http.post(
        Uri.parse('$url/users/update/user'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode({
          "firstname": user.firstName,
          "lastname": user.lastName,
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
}
