import 'package:flutter/material.dart';

class CustElevatedButton extends StatelessWidget {
  final String btnText;
  final Function()? onPressed;
  final Color? textColor;
  final MaterialStateProperty<BorderSide?>? side;
  const CustElevatedButton({
    Key? key,
    this.btnText = "Button Text",
    this.onPressed,
    this.side,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(60, 60),
        ),
        side: side,
        elevation: MaterialStateProperty.all<double>(0.0),
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.primary,
        ),
      ),
      onPressed: onPressed,
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            btnText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: textColor ?? Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}
