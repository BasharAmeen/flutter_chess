import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../logic/providers/online_game_controller.dart';
import '../../configuration/responsive.dart';
import '../../screens/home_screen.dart';
import 'drawer.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    this.screen,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);
  final String text;
  final Widget? screen;
  final double screenWidth;
  final double screenHeight;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          Responsive.isDesktop(context) ? screenWidth / 3.2 : screenWidth / 2.2,
      height: Responsive.isDesktop(context)
          ? screenHeight / 13
          : screenHeight / 13.16,
      child: OutlinedButton(
        onPressed: () async {
          if (text == 'Play Online') {
            // var provider = context.read<OnlineGameController>();
            // provider.createNewGame();
            modelSheet();
            return;
          }
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return screen ?? const DrawerDesign();
            },
          ));
        },
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Colors.black.withOpacity(0.4)),
          elevation: MaterialStateProperty.all(8),
          overlayColor: MaterialStateProperty.all(Colors.green),
          side: MaterialStateProperty.all(
              const BorderSide(color: Colors.deepPurpleAccent, width: 1.2)),
          visualDensity: const VisualDensity(
            horizontal: 3,
            vertical: 4,
          ),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        ),
        child: FittedBox(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 2.3,
              fontSize: 18.sp,
            ),
          ),
        ),
      ),
    );
  }
}
