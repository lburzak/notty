import 'package:flutter/cupertino.dart';
import 'package:notty/controller/selection_controller.dart';
import 'package:provider/provider.dart';

class SelectableItem extends StatelessWidget {
  final SelectionController controller;
  final Widget Function(bool selected) create;
  final int index;

  const SelectableItem(
      {Key? key,
        required this.controller,
        required this.create,
        required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionController>(
        builder: (context, selection, child) => GestureDetector(
            child: create(controller.isSelected(index)),
            onTap: () {
              if (controller.isEnabled) controller.toggle(index);
            },
            onLongPress: () {
              if (!controller.isEnabled) controller.beginSelection(index);
            }));
  }
}
