import 'package:flutter/material.dart';

class BackgroundImageFb0 extends StatelessWidget {
  final Widget child;
  final String imageUrl;

  const BackgroundImageFb0(
      {required this.child, required this.imageUrl, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            alignment: Alignment.center),
      ),
      child: child,
    );
  }
}
