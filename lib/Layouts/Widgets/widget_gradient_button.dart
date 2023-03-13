import 'package:flutter/material.dart';
import '../../Global/functions.dart';

class Button extends StatelessWidget {
  final Widget? icon;
  final double width;
  final double height;
  final String page;
  final String buttonType;
  const Button(
      {required this.width,
      required this.height,
      this.icon,
      required this.page,
      required this.buttonType,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          width: width,
          height: height,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black),
          ),
          alignment: Alignment.center,
          child: icon),
      onTap: () {
        navigate(context, page);
      },
    );
  }
}
