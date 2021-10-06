import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:iig_interview/module/models/status_api.dart';

abstract class UserStore {
  Future<StatusAPI> login(username, password);
}

class User implements UserStore {
  var url = "https://backend.notheart.xyz";
  var header = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  @override
  Future<StatusAPI> login(username, password) async {
    http.Response response = await http.post(Uri.parse('$url/users/login'),
        headers: header,
        body: jsonEncode({"username": username, "password": password}));
    return StatusAPI.fromJson(jsonDecode(response.body));
  }
}
