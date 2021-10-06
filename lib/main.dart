import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iig_interview/module/providers/current_user.dart';
import 'package:iig_interview/page/register.dart';
import 'package:provider/provider.dart';
//import 'package:iig_interview/components/administrator/register.dart';
//import 'package:iig_interview/module/providers/current_user.dart';
import 'package:iig_interview/page/home.dart';
import 'package:iig_interview/page/login.dart';
import 'package:vrouter/vrouter.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => CurrentUserProvince(),
        lazy: false,
      ),
    ],
    child: const Router(),
  ));
}

class Router extends StatefulWidget {
  const Router({Key? key}) : super(key: key);

  @override
  _RouterState createState() => _RouterState();
}

class _RouterState extends State<Router> {
  @override
  Widget build(BuildContext context) {
    return VRouter(mode: VRouterMode.history, routes: [
      VGuard(
          beforeEnter: (vRedirector) async {
            //CurrentUserProvince province = context.watch<CurrentUserProvince>();
            CurrentUserProvince province =
                Provider.of<CurrentUserProvince>(context);
            if (province.token != null) return vRedirector.to("/home");
            /*if (province.token != null) {
              return vRedirector.to("/home");
            }  else if (province.expiredAt!
                .isBefore(DateTime.now().add(const Duration(minutes: 10)))) {
              // check expiredAt lower 10 m
              print("refresh token");
            }*/
          },
          stackedRoutes: [
            VWidget(path: '/login', widget: const LoginPage(), name: 'login'),
            VWidget(
                path: '/register',
                widget: const RegisterPage(),
                name: 'register'),
          ]),
      VGuard(
          beforeEnter: (vRedirector) async {
            CurrentUserProvince province =
                Provider.of<CurrentUserProvince>(context);
            if (province.token == null) {
              return vRedirector.to("/login");
            } else if (context
                .watch<CurrentUserProvince>()
                .expiredAt!
                .isBefore(DateTime.now().add(const Duration(minutes: 10)))) {
              // check expiredAt lower 10 m
              print("refresh token");
            }
          },
          stackedRoutes: [
            VWidget(path: "/home", widget: const HomePage(), name: 'home')
          ]),
      VRouteRedirector(path: '', redirectTo: '/login'),
      VRouteRedirector(path: '*', redirectTo: '/login'),
    ]);
  }
}
