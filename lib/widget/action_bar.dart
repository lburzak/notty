import 'package:flutter/material.dart';
import 'package:notty/widget/bottom_bar.dart';

class ActionBar extends StatefulWidget {
  final bool visible;
  final void Function()? onCancel;
  final void Function()? onAction;

  const ActionBar({Key? key, this.visible = true, this.onCancel, this.onAction})
      : super(key: key);

  @override
  State<ActionBar> createState() => _ActionBarState();
}

class _ActionBarState extends State<ActionBar>
    with SingleTickerProviderStateMixin {
  bool _visible = false;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  )..addStatusListener((status) {
      setState(() {
        switch (status) {
          case AnimationStatus.forward:
            _visible = true;
            break;
          case AnimationStatus.dismissed:
            _visible = false;
            break;
          default:
        }
      });
    });

  @override
  Widget build(BuildContext context) {
    if (widget.visible)
      _controller.forward();
    else
      _controller.reverse();

    return Visibility(
      visible: _visible,
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset(0, -1), end: Offset.zero)
            .animate(_controller),
        child: Material(
          elevation: 2,
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
                    BottomBarButton(
                      icon: Icons.close,
                      onPressed: widget.onCancel,
                    ),
                    BottomBarButton(
                      icon: Icons.delete,
                      onPressed: widget.onAction,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
