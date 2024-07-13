import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Loading ...'),
            SizedBox(
              width: 16,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
