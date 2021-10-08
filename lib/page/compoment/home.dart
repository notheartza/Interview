import 'package:flutter/material.dart';
import 'package:iig_interview/module/api/users.dart';
import 'package:iig_interview/module/providers/current_user.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

class HomeCompoment extends StatefulWidget {
  const HomeCompoment({Key? key}) : super(key: key);

  @override
  _HomeCompomentState createState() => _HomeCompomentState();
}

class _HomeCompomentState extends State<HomeCompoment> {
  final UserStore userapi = User();
  @override
  Widget build(BuildContext context) {
    CurrentUserProvince userProvider =
        Provider.of<CurrentUserProvince>(context, listen: false);
    return const Center(
      child: Text("welcome"),
    );
  }
}
