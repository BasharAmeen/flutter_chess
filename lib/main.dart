import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'logic/providers/auth.dart';
import 'logic/providers/mult_providers_list.dart';
import 'ui/screens/home_screen.dart';

import 'firebase_options.dart';
import 'ui/configuration/themes.dart';
import 'ui/screens/signing/auth_screen.dart';
import 'ui/screens/signing/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

GlobalKey<NavigatorState> scaffoldKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: multiProvidersList(),
      builder: (BuildContext context, __) {
        return ScreenUtilInit(
            splitScreenMode: true,
            designSize: const Size(395, 658),
            builder: (_, __) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  color: Colors.black87,
                  title: 'Chess',
                  theme: context.read<Themes>().whiteTheme,
                  darkTheme: context.read<Themes>().darkTheme,
                  themeMode: context.watch<Themes>().isDark
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  home: SafeArea(
                      key: scaffoldKey,
                      child: context.watch<Auth>().isAuth
                          ? const HomeScreen()
                          : FutureBuilder(
                              future: context.read<Auth>().tryAutoLogin(),
                              builder: (ctx, snapShot) {
                                return snapShot.connectionState ==
                                        ConnectionState.waiting
                                    ? const SplashScreen()
                                    : const AuthScreen(isLogin: false);
                              })),
                ));
      },
    );
  }
}

extension ContainsList on List {
  bool containsList(List other) {
    if (length != other.length) return false;

    for (int i = 0; i < length; i++) {
      if (this[i] != other[i]) return false;
    }

    return true;
  }
}

extension FirstTwoWords on String {
  String firstTwoWords() {
    List<String> temp = split(' ');
    return temp.length == 1 ? temp[0] : '${temp[0]} ${temp[1]}';
  }
}
