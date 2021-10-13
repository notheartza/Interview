import 'package:flutter/material.dart';
import 'package:iig_interview/module/api/users.dart';
import 'package:iig_interview/module/providers/current_user.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

class HomePage extends StatefulWidget {
  final Widget? compoment;
  const HomePage({Key? key, this.compoment}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserStore userapi = User();
  @override
  Widget build(BuildContext context) {
    CurrentUserProvince userProvider =
        Provider.of<CurrentUserProvince>(context, listen: false);
    return FutureBuilder(
      future: userProvider.getToken(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Dialog(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  Text("Loading"),
                ],
              ),
            );
          default:
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      context.vRouter.to("/home");
                    },
                    icon: const Icon(Icons.home)),
                title: const Text("I&I Group Interview"),
                actions: [
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.menu),
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          child: const Text("Profile"),
                          onTap: () {
                            context.vRouter.to("/profile");
                          },
                        ),
                        PopupMenuItem<String>(
                          child: const Text("Logout"),
                          onTap: () async {
                            var userData = await userapi.logout();
                            if (userData.status == 200) {
                              setState(() {
                                userProvider.logoutUser();
                              });
                              context.vRouter.to("/login");
                            } else if (userData.status > 400) {
                              userData = await userapi.refreshToken();
                              if (userData.status == 200) {
                                setState(() {
                                  userProvider.logoutUser();
                                });

                                context.vRouter.to("/login");
                              }
                            }
                          },
                        )
                      ].toList();
                    },
                  ),
                ],
              ),
              body: widget.compoment,
            );
        }
      },
    );
  }
}
