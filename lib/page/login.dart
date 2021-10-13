import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iig_interview/module/api/users.dart';
import 'package:iig_interview/module/models/current_user.dart';
import 'package:iig_interview/module/providers/current_user.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final UserStore userapi = User();
  var _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    CurrentUserProvince provider =
        Provider.of<CurrentUserProvince>(context, listen: false);
    return Scaffold(
      body: Center(
          child: SizedBox(
        width: 350,
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: IntrinsicHeight(
                    child: Form(
                  key: _loginKey,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: SelectableText("I&I Group Interview"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                                labelText: "username",
                                border: OutlineInputBorder(),
                                hintText: "Enter your username"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a your username';
                              }
                              return null;
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          obscureText: !_passwordVisible,
                          controller: _passController,
                          decoration: InputDecoration(
                              labelText: "Password",
                              border: const OutlineInputBorder(),
                              hintText: "Enter your Password",
                              suffixIcon: IconButton(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                                icon: Icon((_passwordVisible)
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                color: Theme.of(context).primaryColorDark,
                              )),
                          validator: (value) {
                            RegExp regEx =
                                RegExp(r"(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])\w+");
                            RegExp regEx1 = RegExp(r"(?=.*[~!?@#$%^&*-])\w+");
                            if (value!.length < 6) {
                              return "password Must be at least 6 characters";
                            } else if (!regEx.hasMatch(value)) {
                              return "password Must 1 digit 1 lowercase and 1 uppercase";
                            } else if (regEx1.hasMatch(value)) {
                              return "password can't use ~ ! ? @ # \$ % ^ & *";
                            }
                          },
                        ),
                      ),
                      Center(
                          child: TextButton(
                              onPressed: () {
                                context.vRouter.toNamed('register');
                              },
                              child: const Text("สมัครสมาชิก"))),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blue),
                            onPressed: () async {
                              if (_loginKey.currentState!.validate()) {
                                if (_emailController.text.isNotEmpty &&
                                    _passController.text.isNotEmpty) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            CircularProgressIndicator(),
                                            Text("Loading"),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                  var userData = await userapi.login(
                                      _emailController.text,
                                      _passController.text);
                                  Navigator.pop(context); //pop loading
                                  if (userData.status > 200) {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(_);
                                                  },
                                                  child: const Text("Ok"),
                                                ),
                                              ],
                                              title: const Text("Alert!"),
                                              content: Text(
                                                  userData.message['message']),
                                            ));
                                  } else {
                                    var user = CurrentUser.fromJson(
                                        userData.message['currentUser']);
                                    var token = userData.message['token'];
                                    await provider.setUser(user, token);
                                    context.vRouter.toNamed('home');
                                  }
                                }
                              }
                            },
                            child: const Padding(
                                child: Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                                padding: EdgeInsets.all(10))),
                      ),
                    ],
                  ),
                )))),
      )),
    );
  }
}
