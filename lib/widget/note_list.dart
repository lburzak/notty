import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notty/controller/selection_controller.dart';
import 'package:notty/models/note.dart';
import 'package:notty/viewmodel/notes_view_model.dart';
import 'package:notty/widget/action_bar.dart';
import 'package:provider/provider.dart';

import 'note_tile.dart';

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

class NotesList extends StatefulWidget {
  final NotesViewModel viewModel;
  final void Function(Set<int> selectedIndices)? onDeleteNotes;
  final Stream<DataEvent> dataEvents;

  const NotesList({Key? key, required this.viewModel, this.onDeleteNotes, required this.dataEvents})
      : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  final ScrollController _scrollController = ScrollController();
  final SelectionController _selectionController = SelectionController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    widget.dataEvents.listen((event) {
      switch (event.type) {
        case DataEventType.add:
          print(event);
          for (var index in event.indices)
            _listKey.currentState!.insertItem(index, duration: Duration(milliseconds: 1000));
          break;
        case DataEventType.remove:
          print(event);
          for (var index in event.indices)
            _listKey.currentState!.removeItem(index, (context, animation) => FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0)),
              child: SizeTransition(
                sizeFactor: CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
                axisAlignment: 0.0,
                child: buildRow(context, index, animation),
              ),
            ),
                duration: Duration(milliseconds: 1000));
          break;
      }
    });
  }

  Widget buildRow(BuildContext ctx, int index, Animation<double> animation) =>
      SelectableItem(
        controller: _selectionController,
        create: (selected) => NoteTile(
          note: widget.viewModel.notes[index],
          selected: selected,
        ),
        index: index,
      );

  void scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).colorScheme.background,
        borderRadius: new BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: ChangeNotifierProvider(
          create: (context) => _selectionController,
          child: Consumer<SelectionController>(
            builder: (context, selection, child) => Column(
              children: [
                ActionBar(
                  visible: selection.isEnabled,
                  onCancel: selection.endSelection,
                  onAction: () {
                    widget.onDeleteNotes!(selection.selectedIndices);
                    selection.endSelection();
                  },
                ),
                Expanded(
                  child: AnimatedList(
                    key: _listKey,
                    padding: _selectionController.isEnabled
                        ? const EdgeInsets.all(8.0)
                        : EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top +
                            8.0,
                        left: 8.0,
                        right: 8.0,
                        bottom: 8.0),
                    itemBuilder: buildRow,
                    initialItemCount: widget.viewModel.notes.length,
                    controller: _scrollController,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
