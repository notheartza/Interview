import 'package:flutter/material.dart';
import 'package:iig_interview/module/providers/current_user.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    CurrentUserProvince userProvider =
        Provider.of<CurrentUserProvince>(context, listen: false);
    return FutureBuilder(
      future: userProvider.getToken(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Text('Loading....');
          default:
            return Text('Result: ${snapshot.data}');
        }
      },
    );
  }
}
