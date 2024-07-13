import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../configuration/responsive.dart';

class Profile extends StatelessWidget {
  const Profile(
      {Key? key,
      required this.image,
      required this.level,
      this.isFriend,
      required this.name})
      : super(key: key);
  final ImageProvider image;
  final bool? isFriend;
  final int level;
  final String name;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = Responsive.isDesktop(context);
    return isDesktop && isFriend == null
        ? IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 70,
                  width: (screenWidth / 8 * 2.5),
                  child: CardWidget(
                      image: image,
                      name: name,
                      level: level,
                      isDesktop: isDesktop),
                ),
              ],
            ),
          )
        : SizedBox(
            height: 70,
            child: CardWidget(
                image: image, name: name, level: level, isDesktop: false),
          );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key? key,
    required this.image,
    required this.name,
    required this.level,
    required this.isDesktop,
  }) : super(key: key);

  final ImageProvider<Object> image;
  final String name;
  final int level;
  final bool isDesktop;
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.transparent,
        elevation: 0.1,
        shape: OutlineInputBorder(
            borderRadius: isDesktop
                ? const BorderRadius.all(Radius.circular(8))
                : const BorderRadius.all(Radius.circular(30)),
            borderSide: const BorderSide(color: Colors.black)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: ProfileImage(assetImage: image),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const Expanded(
                flex: 2,
                child: Text(''),
              ),
              Expanded(
                flex: 2,
                child: CircleAvatar(
                    backgroundColor: Colors.yellow.withOpacity(0.6),
                    child: Text(
                      '$level',
                      style: const TextStyle(color: Colors.black),
                    )),
              ),
            ],
          ),
        ));
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    Key? key,
    required this.assetImage,
  }) : super(key: key);

  final ImageProvider<Object> assetImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.w,
      height: 62.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: assetImage, fit: BoxFit.fitHeight),
      ),
    );
  }
}
