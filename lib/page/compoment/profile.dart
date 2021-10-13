import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:iig_interview/module/api/users.dart';
import 'package:iig_interview/module/models/current_user.dart';
import 'package:iig_interview/module/providers/current_user.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';

class ProfileCompoment extends StatefulWidget {
  const ProfileCompoment({Key? key}) : super(key: key);

  @override
  _ProfileCompomentState createState() => _ProfileCompomentState();
}

class _ProfileCompomentState extends State<ProfileCompoment> {
  final UserStore userapi = User();
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _rePassController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  String? preimg;
  var _oldpasswordVisible = false;
  var _newpasswordVisible = false;
  var _repasswordVisible = false;
  final _resetKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    CurrentUserProvince provider =
        Provider.of<CurrentUserProvince>(context, listen: false);
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            SharedPreferences prefs = snapshot.data;
            String get = prefs.getString("CurrentUser") ?? jsonEncode({});
            CurrentUser user = CurrentUser.fromJson(jsonDecode(get));
            _emailController.text = user.email!;
            _firstnameController.text = user.firstName!;
            _lastnameController.text = user.lastName!;
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      child: SizedBox(
                        width: 550,
                        height: 450,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(10),
                                // ignore: prefer_const_constructors
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: (preimg != null)
                                          ? CircleAvatar(
                                              radius: 40,
                                              backgroundImage: MemoryImage(
                                                  base64Decode(preimg!)))
                                          : (user.image == null)
                                              ? const CircleAvatar(
                                                  radius: 40,
                                                  backgroundImage: AssetImage(
                                                      'images/no-image.png'))
                                              : CircleAvatar(
                                                  radius: 40,
                                                  backgroundImage: MemoryImage(
                                                      base64Decode(
                                                          user.image!))),
                                    ),
                                    (preimg == null)
                                        ? IconButton(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            onPressed: () async {
                                              Uint8List? pick =
                                                  (await ImagePickerWeb
                                                          .getImage(
                                                              outputType:
                                                                  ImageType
                                                                      .bytes))
                                                      as Uint8List?;
                                              setState(() {
                                                preimg = base64Encode(pick!);
                                              });
                                            },
                                            icon: const Icon(Icons.edit))
                                        : IconButton(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            onPressed: () async {
                                              user.image = preimg;
                                              var userData = await userapi
                                                  .updateUser(user);
                                              if (userData.status == 200) {
                                                var update =
                                                    await userapi.getuser();
                                                provider.updateUser(
                                                    CurrentUser.fromJson(
                                                        update.message));
                                                setState(() {
                                                  preimg = null;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.save)),
                                  ],
                                )),
                            Text('USERNAME : ${user.username!}'),
                            Form(
                                key: _resetKey,
                                child: Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: TextFormField(
                                            obscureText: !_oldpasswordVisible,
                                            controller: _oldPassController,
                                            decoration: InputDecoration(
                                                labelText: "Old Password",
                                                border:
                                                    const OutlineInputBorder(),
                                                hintText: "Enter your Password",
                                                suffixIcon: IconButton(
                                                  highlightColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  onPressed: () {
                                                    setState(() {
                                                      _oldpasswordVisible =
                                                          !_oldpasswordVisible;
                                                    });
                                                  },
                                                  icon: Icon(
                                                      (_oldpasswordVisible)
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off),
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
                                              } else if (!regEx
                                                  .hasMatch(value)) {
                                                return "password Must 1 digit 1 lowercase and 1 uppercase";
                                              } else if (regEx1
                                                  .hasMatch(value)) {
                                                return "password can't use ~ ! ? @ # \$ % ^ & *";
                                              }
                                            })),
                                    Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: TextFormField(
                                            obscureText: !_newpasswordVisible,
                                            controller: _newPassController,
                                            decoration: InputDecoration(
                                                labelText: "Password",
                                                border:
                                                    const OutlineInputBorder(),
                                                hintText: "Enter your Password",
                                                suffixIcon: IconButton(
                                                  highlightColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  onPressed: () {
                                                    setState(() {
                                                      _newpasswordVisible =
                                                          !_newpasswordVisible;
                                                    });
                                                  },
                                                  icon: Icon(
                                                      (_newpasswordVisible)
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off),
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
                                              } else if (!regEx
                                                  .hasMatch(value)) {
                                                return "password Must 1 digit 1 lowercase and 1 uppercase";
                                              } else if (regEx1
                                                  .hasMatch(value)) {
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
                                                  splashColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  onPressed: () {
                                                    setState(() {
                                                      _repasswordVisible =
                                                          !_repasswordVisible;
                                                    });
                                                  },
                                                  icon: Icon(
                                                      (_repasswordVisible)
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off),
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                )),
                                            validator: (value) {
                                              RegExp regEx = RegExp(
                                                  r"(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])\w+");
                                              RegExp regEx1 = RegExp(
                                                  r"(?=.*[~!?@#$%^&*-])\w+");
                                              if (value !=
                                                  _newPassController.text) {
                                                return "password is not same";
                                              } else if (value!.length < 6) {
                                                return "password Must be at least 6 characters";
                                              } else if (!regEx
                                                  .hasMatch(value)) {
                                                return "password Must 1 digit 1 lowercase and 1 uppercase";
                                              } else if (regEx1
                                                  .hasMatch(value)) {
                                                return "password can't use ~ ! ? @ # \$ % ^ & *";
                                              }
                                              return null;
                                            }))
                                  ],
                                )),
                            TextButton(
                                onPressed: () async {
                                  if (_resetKey.currentState!.validate()) {
                                    var userData = await userapi.resetpassword(
                                        _oldPassController.text,
                                        _newPassController.text);
                                    //print(userData);

                                    if (userData.status > 200) {
                                      var message =
                                          jsonDecode(userData.message);
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
                                                content:
                                                    Text(message['message']),
                                              ));
                                    } else {
                                      setState(() {
                                        provider.logoutUser();
                                      });
                                    }

                                    context.vRouter.to("/login");
                                  }
                                },
                                child: const Text("save"))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                      child: SizedBox(
                    width: 550,
                    child: Column(
                      children: [
                        Container(
                          width: 500,
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
                              }),
                        ),
                        Container(
                            width: 500,
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                                controller: _firstnameController,
                                decoration: const InputDecoration(
                                    labelText: "firstname",
                                    border: OutlineInputBorder(),
                                    hintText: "Enter your firstname"),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a firstname';
                                  }
                                  return null;
                                })),
                        Container(
                          width: 500,
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                              controller: _lastnameController,
                              decoration: const InputDecoration(
                                  labelText: "lastname",
                                  border: OutlineInputBorder(),
                                  hintText: "Enter your lastname"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a lastname';
                                }
                                return null;
                              }),
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    user.email = _emailController.text;
                                    user.firstName = _firstnameController.text;
                                    user.lastName = _lastnameController.text;
                                    var userData =
                                        await userapi.updateUser(user);
                                    if (userData.status == 200) {
                                      var update = await userapi.getuser();
                                      setState(() {
                                        provider.updateUser(
                                            CurrentUser.fromJson(
                                                update.message));
                                      });
                                    }
                                  },
                                  child: const Text("Save"))
                            ],
                          ),
                        )
                      ],
                    ),
                  ))
                ],
              ),
            );
          } else {
            return Dialog(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  Text("Loading"),
                ],
              ),
            );
          }
        });
  }
}
