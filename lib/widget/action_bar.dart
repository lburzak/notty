import 'package:flutter/material.dart';
import 'package:notty/widget/bottom_bar.dart';

class ActionBar extends StatelessWidget {
  final bool visible;
  final void Function()? onCancel;
  final void Function()? onAction;

  const ActionBar({Key? key, this.visible = true, this.onCancel, this.onAction}) : super(key: key);

  @override
  Widget build(BuildContext context) => Visibility(
    visible: visible,
    child: Material(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Container(
          height: 50,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BottomBarButton(icon: Icons.close, onPressed: onCancel,),
                BottomBarButton(icon: Icons.delete, onPressed: onAction,)
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
