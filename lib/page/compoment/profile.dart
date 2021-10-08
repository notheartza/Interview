import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:iig_interview/module/api/users.dart';
import 'package:iig_interview/module/models/current_user.dart';
import 'package:iig_interview/module/providers/current_user.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCompoment extends StatefulWidget {
  const ProfileCompoment({Key? key}) : super(key: key);

  @override
  _ProfileCompomentState createState() => _ProfileCompomentState();
}

class _ProfileCompomentState extends State<ProfileCompoment> {
  final UserStore userapi = User();
  final _emailController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  String? preimg;
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
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      child: SizedBox(
                        width: 550,
                        height: 150,
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
                            Text('USERNAME : ${user.username!}')
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
                        Container()
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
