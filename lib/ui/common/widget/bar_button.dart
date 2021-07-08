import 'package:flutter/material.dart';

class BarButton extends StatelessWidget {
  BarButton({Key? key, required this.icon, this.onPressed}) : super(key: key);

  final void Function()? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 32,
    child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(this.icon)
    ),
  );
}
