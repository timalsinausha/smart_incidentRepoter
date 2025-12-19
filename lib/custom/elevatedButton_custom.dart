import 'package:flutter/material.dart';

class ElevetedButton_custom extends StatelessWidget {
  ElevetedButton_custom({super.key, this.child, this.onPressed});
  void Function()? onPressed;
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xff007958),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: onPressed,
            child: child),
      ),
    );
  }
}