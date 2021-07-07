import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notty/controller/selection_controller.dart';
import 'package:notty/models/note.dart';
import 'package:notty/viewmodel/notes_view_model.dart';
import 'package:notty/widget/action_bar.dart';
import 'package:notty/adapter/animated_list_stream_adapter.dart';
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

  const NotesList(
      {Key? key,
      required this.viewModel,
      this.onDeleteNotes,
      required this.dataEvents})
      : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  final ScrollController _scrollController = ScrollController();
  final SelectionController _selectionController = SelectionController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  late final AnimatedListStreamAdapter<Note> animatedListController =
    AnimatedListStreamAdapter(
        itemBuilder: buildRowDummy,
        stateKey: _listKey,
        stream: widget.viewModel.notesStream
    );

  Widget buildRowIndex(BuildContext ctx, int index, Animation<double> animation) =>
      SelectableItem(
        controller: _selectionController,
        create: (selected) => NoteTile(
          note: animatedListController.items[index],
          selected: selected,
        ),
        index: index,
      );
  
  Widget buildRowDummy(BuildContext ctx, Note note, Animation<double> animation) =>
      NoteTile(
        note: note,
        selected: false,
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
                            top: MediaQuery.of(context).padding.top + 8.0,
                            left: 8.0,
                            right: 8.0,
                            bottom: 8.0),
                    itemBuilder: buildRowIndex,
                    initialItemCount: animatedListController.items.length,
                    controller: _scrollController,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
