import 'package:flutter/material.dart';
import 'package:sabia_app/Constants/Constants.dart';

class RoundedButton extends StatelessWidget {
  final String btnText;
  final Function onBtnPressed;

  const RoundedButton(
      {Key? key, required this.btnText, required this.onBtnPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: primaryColor,
      borderRadius: BorderRadius.circular(25),
      child: MaterialButton(
        onPressed: () => onBtnPressed(),
        minWidth: 320,
        height: 60,
        child: Text(
          btnText,
          style: const TextStyle(color: defaultDarkColor, fontSize: 20),
        ),
      ),
    );
  }
}

//#15a00000
