import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:iig_interview/module/api/users.dart';
import 'package:iig_interview/module/models/current_user.dart';
import 'package:iig_interview/module/providers/current_user.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  CurrentUser user = CurrentUser.fromJson({
    "email": "",
    "firstName": "",
    "lastName": "",
    "username": "",
    "image": ""
  });
  final _registerKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passController = TextEditingController();
  final _rePassController = TextEditingController();
  final UserStore userapi = User();
  var _passwordVisible = false;
  var _repasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    CurrentUserProvince provider =
        Provider.of<CurrentUserProvince>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("I&I Group"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
              child: Card(
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      width: 550,
                      child: Form(
                        key: _registerKey,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text("Register"),
                            ),
                            (user.image!.isEmpty)
                                ? const CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        AssetImage('images/no-image.png'))
                                : CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        MemoryImage(base64Decode(user.image!))),
                            TextButton(
                              onPressed: () async {
                                Uint8List? pick =
                                    (await ImagePickerWeb.getImage(
                                            outputType: ImageType.bytes))
                                        as Uint8List?;
                                setState(() {
                                  user.image = base64Encode(pick!);
                                });
                              },
                              child: const Text("Select"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextFormField(
                                          controller: _userNameController,
                                          decoration: const InputDecoration(
                                              labelText: "username",
                                              border: OutlineInputBorder(),
                                              hintText: "Enter your username"),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter a username';
                                            } else if (value.length > 12) {
                                              return 'Please enter a username';
                                            }
                                            return null;
                                          })),
                                  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextFormField(
                                          obscureText: !_passwordVisible,
                                          controller: _passController,
                                          decoration: InputDecoration(
                                              labelText: "Password",
                                              border:
                                                  const OutlineInputBorder(),
                                              hintText: "Enter your Password",
                                              suffixIcon: IconButton(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                onPressed: () {
                                                  setState(() {
                                                    _passwordVisible =
                                                        !_passwordVisible;
                                                  });
                                                },
                                                icon: Icon((_passwordVisible)
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                              )),
                                          validator: (value) {
                                            RegExp regEx = RegExp(
                                                r"(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])\w+");
                                            RegExp regEx1 = RegExp(
                                                r"(?=.*[~!?@#$%^&*-])\w+");
                                            if (value!.length < 6) {
                                              return "password Must be at least 6 characters";
                                            } else if (!regEx.hasMatch(value)) {
                                              return "password Must 1 digit 1 lowercase and 1 uppercase";
                                            } else if (regEx1.hasMatch(value)) {
                                              return "password can't use ~ ! ? @ # \$ % ^ & *";
                                            }
                                          })),
                                  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextFormField(
                                          obscureText: !_repasswordVisible,
                                          controller: _rePassController,
                                          decoration: InputDecoration(
                                              labelText: "Re-Password",
                                              border:
                                                  const OutlineInputBorder(),
                                              hintText: "Enter your Password",
                                              suffixIcon: IconButton(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                onPressed: () {
                                                  setState(() {
                                                    _repasswordVisible =
                                                        !_repasswordVisible;
                                                  });
                                                },
                                                icon: Icon((_repasswordVisible)
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                              )),
                                          validator: (value) {
                                            RegExp regEx = RegExp(
                                                r"(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])\w+");
                                            RegExp regEx1 = RegExp(
                                                r"(?=.*[~!?@#$%^&*-])\w+");
                                            if (value != _passController.text) {
                                              return "password is not same";
                                            } else if (value!.length < 6) {
                                              return "password Must be at least 6 characters";
                                            } else if (!regEx.hasMatch(value)) {
                                              return "password Must 1 digit 1 lowercase and 1 uppercase";
                                            } else if (regEx1.hasMatch(value)) {
                                              return "password can't use ~ ! ? @ # \$ % ^ & *";
                                            }
                                            return null;
                                          })),
                                  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextFormField(
                                          controller: _emailController,
                                          decoration: const InputDecoration(
                                              labelText: "email",
                                              border: OutlineInputBorder(),
                                              hintText: "Enter your email"),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter a email';
                                            }
                                            return null;
                                          })),
                                  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextFormField(
                                          controller: _firstNameController,
                                          decoration: const InputDecoration(
                                              labelText: "Firstname",
                                              border: OutlineInputBorder(),
                                              hintText: "Enter your Firstname"),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter a Firstname';
                                            }
                                            return null;
                                          })),
                                  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextFormField(
                                          controller: _lastNameController,
                                          decoration: const InputDecoration(
                                              labelText: "Lastname",
                                              border: OutlineInputBorder(),
                                              hintText: "Enter your Lastname"),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter a Lastname';
                                            }
                                            return null;
                                          })),
                                  TextButton(
                                      onPressed: () async {
                                        if (_registerKey.currentState!
                                            .validate()) {
                                          user.username =
                                              _userNameController.text;
                                          user.email = _emailController.text;
                                          user.firstName =
                                              _firstNameController.text;
                                          user.lastName =
                                              _lastNameController.text;
                                          var userData = await userapi.signup(
                                              user, _passController.text);
                                          if (userData.status > 200) {
                                            print(userData.message);
                                            showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(_);
                                                          },
                                                          child:
                                                              const Text("Ok"),
                                                        ),
                                                      ],
                                                      title:
                                                          const Text("Alert!"),
                                                      content: Text(userData
                                                          .message['message']),
                                                    ));
                                          } else {
                                            var user = CurrentUser.fromJson(
                                                userData
                                                    .message['currentUser']);
                                            var token =
                                                userData.message['token'];
                                            await provider.setUser(user, token);
                                            context.vRouter.toNamed('home');
                                          }
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Text("register"),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))))),
    );
  }
}
