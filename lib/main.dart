import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iig_interview/module/providers/current_user.dart';
import 'package:iig_interview/page/compoment/profile.dart';
import 'package:iig_interview/page/home.dart';
import 'package:iig_interview/page/register.dart';
import 'package:provider/provider.dart';
import 'package:iig_interview/page/compoment/home.dart';
import 'package:iig_interview/page/login.dart';
import 'package:vrouter/vrouter.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => CurrentUserProvince(),
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
    CurrentUserProvince userProvider =
        Provider.of<CurrentUserProvince>(context, listen: false);
    return VRouter(
      mode: VRouterMode.history,
      routes: [
        VGuard(
            beforeEnter: (vRedirector) async {
              var token = await userProvider.getToken();
              if (token.isNotEmpty) {
                return vRedirector.to("/home");
              }
            },
            beforeUpdate: (vRedirector) async {
              var token = await userProvider.getToken();
              if (token.isNotEmpty) {
                return vRedirector.to("/home");
              }
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
              var token = await userProvider.getToken();
              if (token.isEmpty) {
                return vRedirector.to("/login");
              } /*else if (userProvider.expiredAt != null &&
                  userProvider.expiredAt!.isBefore(
                      DateTime.now().add(const Duration(minutes: 10)))) {
                // check expiredAt lower 10 m
                print("refresh token");
              }*/
            },
            beforeUpdate: (vRedirector) async {
              var token = await userProvider.getToken();
              if (token.isEmpty) {
                return vRedirector.to("/login");
              }
            },
            stackedRoutes: [
              VNester(
                  path: "",
                  widgetBuilder: (child) => HomePage(
                        compoment: child,
                      ),
                  nestedRoutes: [
                    VWidget(
                        path: "home",
                        widget: const HomeCompoment(),
                        name: 'home'),
                    VWidget(
                        path: "profile",
                        widget: const ProfileCompoment(),
                        name: 'profile')
                  ])
            ]),
        VRouteRedirector(path: '', redirectTo: '/login'),
        VRouteRedirector(path: '*', redirectTo: '/login'),
      ],
    );
  }
}
