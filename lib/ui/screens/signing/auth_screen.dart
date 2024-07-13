import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../logic/providers/auth.dart';

import '../../../main.dart';
import '../../configuration/responsive.dart';
import '../../configuration/themes.dart';
import 'error_dialog.dart';
import 'colors.dart' as my_colors;

bool visible1 = true;
var icon1 = const Icon(Icons.visibility);

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.isLogin});
  final bool isLogin;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final focus = FocusNode();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  late bool isLogin;

  @override
  void initState() {
    isLogin = widget.isLogin;
    super.initState();
  }

  double opacity = 1;
  bool check = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  'assets/Images/background.svg',
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                ),
              ],
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInCirc,
              opacity: opacity,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Responsive.isTablet(context)
                        ? 150
                        : Responsive.isDesktop(context)
                            ? 400
                            : 20),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ListView(
                  primary: false,
                  children: [
                    const Padding(padding: EdgeInsets.fromLTRB(30, 60, 30, 30)),
                    SizedBox(
                      width: 100,
                      height: 80,
                      child: Row(children: [
                        Expanded(
                          flex: 10,
                          child: FittedBox(
                            child: Text(isLogin ? "Sign In " : "Sign Up ",
                                style: TextStyle(
                                  color: my_colors.divider,
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 20,
                          child: Divider(
                            endIndent: 32,
                            color: my_colors.divider,
                            thickness: 1.3,
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                      ]),
                    ),

                    if (!isLogin)
                      CustomFormFiled(
                        controller: name,
                        hintText: "Name",
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                      ),
                    CustomFormFiled(
                      controller: email,
                      hintText: "E-mail",
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),

                    CustomFormFiled(
                      controller: password,
                      hintText: "Password",
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        iconSize: 24,
                        icon: icon1,
                        onPressed: () {
                          setState(() {
                            visible1 = !visible1;
                            visible1 == false
                                ? icon1 = const Icon(Icons.visibility_off)
                                : icon1 = const Icon(Icons.visibility);
                          });
                        },
                      ),
                      obscureText: visible1,
                    ),
                    if (isLogin)
                      Container(
                        alignment: Alignment.topRight,
                        child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(
                                color: Color(0xff42CDF3),
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),

                    const SizedBox(height: 32),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 85),
                      child: ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            try {
                              setState(() {
                                check = true;
                              });

                              if (isLogin) {
                                await context.read<Auth>().signIn(
                                      email: email.text.toLowerCase(),
                                      password: password.text,
                                    );

                                if (mounted) {
                                  setState(() {
                                    check = false;
                                  });
                                }
                                scaffoldKey.currentContext!
                                    .read<Themes>()
                                    .swithMode(true);
                              } else {
                                await context.read<Auth>().signUp(
                                      email: email.text.toLowerCase(),
                                      password: password.text,
                                      userName: name.text,
                                    );
                                AlertDialog alert = const AlertDialog(
                                  backgroundColor: Colors.black,
                                  title: Text("E-Mail Created!"),
                                  content: Text(' All done, now you can login'),
                                  titleTextStyle: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  contentTextStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                );
                                await showDialog(
                                    useSafeArea: true,
                                    context: context,
                                    barrierColor: Colors.white60,
                                    builder: (_) {
                                      return alert;
                                    });
                                if (mounted) {
                                  setState(() {
                                    isLogin = !isLogin;
                                    check = false;
                                  });
                                }
                              }
                            } catch (e) {
                              errorDialog(e.toString(), context);
                              setState(() {
                                check = false;
                              });
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.purple),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            elevation: MaterialStateProperty.all(10),
                          ),
                          child: FittedBox(
                            // padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),

                            child: check
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3, vertical: 3),
                                    width: 30,
                                    height: 30,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    isLogin ? "Login" : "Create account",
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                          )),
                    ),
                    const SizedBox(height: 32),
                    //===============================
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Divider(
                            color: my_colors.divider,
                            thickness: 1.3,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: FittedBox(
                            child: Text(" OR ",
                                style: TextStyle(
                                  color: my_colors.divider,
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Divider(
                            color: my_colors.divider,
                            thickness: 1.3,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons.wb_sunny_outlined,
                          color: Colors.deepPurple,
                        ),
                        Expanded(
                          flex: 2,
                          child: FittedBox(
                            child: Text(
                                isLogin
                                    ? "Don't have an account?"
                                    : " Already have an account?",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        Expanded(
                          child: FittedBox(
                            child: TextButton(
                              onPressed: () {
                                Timer(const Duration(milliseconds: 200), () {
                                  setState(() {
                                    isLogin = !isLogin;
                                    opacity = 1;
                                  });
                                });
                                setState(() {
                                  opacity = 0;
                                });
                              },
                              child: Text(
                                  isLogin ? "Sign Up now!" : "Try logging in!",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomFormFiled extends StatelessWidget {
  const CustomFormFiled({
    Key? key,
    required this.controller,
    required this.keyboardType,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Material(
        elevation: 3,
        shadowColor: my_colors.shadowOfButton,
        borderRadius: BorderRadius.circular(30),
        child: TextField(
          obscureText: obscureText ?? false,
          style: const TextStyle(fontWeight: FontWeight.bold),
          controller: controller,
          textInputAction: TextInputAction.next,
          textAlign: TextAlign.justify,
          textAlignVertical: TextAlignVertical.bottom,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: const EdgeInsets.fromLTRB(28, 0, 5, 40),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xffffffff),
            hintText: hintText,
            hintStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15.6,
            ),
            prefixIcon: prefixIcon,
            focusColor: Colors.red,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
