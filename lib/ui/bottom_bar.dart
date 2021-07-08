import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'common/widget/bar_button.dart';

class BottomBar extends StatefulWidget {
  final void Function(String text)? onNewNote;

  BottomBar(this.onNewNote);

  @override
  State createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool _isExpanded = false;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _inputController.addListener(() {
      _inputController.value = _inputController.value.copyWith(
          text: _inputController.text,
          selection: TextSelection.collapsed(offset: _inputController.text.length)
      );
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _submitNewNote(String content) {
    widget.onNewNote!(content);

    setState(() {
      _inputController.clear();
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
      duration: Duration(milliseconds: 100),
      height: _isExpanded ? 200 : 50,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: BarButton(
                  icon: _isExpanded ? Icons.arrow_downward : Icons.arrow_upward,
                  onPressed: _toggleExpanded
              ),
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                  child: NoteInputBox(
                      controller: _inputController,
                      multiline: _isExpanded,
                      onSubmitted: _submitNewNote),
                )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BarButton(
                  icon: Icons.send,
                  onPressed: () {
                    _submitNewNote(_inputController.text);
                  }),
            ),
          ],
        ),
      )
  );
}

class NoteInputBox extends StatelessWidget {
  final void Function(String text)? onChanged;
  final void Function(String text)? onSubmitted;
  final TextEditingController? controller;
  final bool multiline;

  NoteInputBox({Key? key, this.onChanged, this.onSubmitted, this.multiline = false, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        maxLines: multiline ? 10 : 1,
        style: Theme.of(context).textTheme.bodyText2,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8.0),
            isDense: true,
            hintText: 'Your note...',
            hintStyle: Theme.of(context).textTheme.bodyText2!.apply(
                color: Theme.of(context).textTheme.bodyText2!.color!.withAlpha(85)
            ),
            border: InputBorder.none
        ),
      ),
    );
  }
}