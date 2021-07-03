import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notty/controller/selection_controller.dart';
import 'package:notty/widget/action_bar.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import 'note_tile.dart';

class NotesList extends StatefulWidget {
  final Stream<List<Note>> notes;
  final void Function(Set<int> selectedIndices)? onDeleteNotes;

  const NotesList({Key? key, required this.notes, this.onDeleteNotes}) : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  final ScrollController _scrollController = ScrollController();
  final SelectionController _selectionController = SelectionController();
  bool _selectionMode = false;

  Widget Function(BuildContext ctx, int index) buildRow(List<Note> notes) =>
      (BuildContext ctx, int index) => Consumer<SelectionController>(
            builder: (context, selection, child) => NoteTile(
              note: notes[index],
              selected: selection.isSelected(index),
              onTap: () {
                if (_selectionMode) {
                  selection.toggle(index);
                }
              },
              onLongPress: () {
                setState(() {
                  if (!_selectionMode) _selectionMode = true;
                });
                
                selection.select(index);
              },
            ),
          );

  void scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
  }

  void _endSelection() {
    _selectionController.unselectAll();
    setState(() {
      _selectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).colorScheme.background,
        borderRadius: new BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: Column(
          children: [
            ActionBar(
              visible: _selectionMode,
              onCancel: _endSelection,
              onAction: () {
                widget.onDeleteNotes!(_selectionController.selectedIndices);
                _endSelection();
              },
            ),
            Expanded(
              child: StreamBuilder<List<Note>>(
                  stream: widget.notes,
                  builder: (context, snapshot) => ChangeNotifierProvider(
                        create: (context) => _selectionController,
                        child: ListView.builder(
                          padding: _selectionMode ? const EdgeInsets.all(8.0) : EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 8.0,
                              left: 8.0,
                              right: 8.0,
                              bottom: 8.0
                          ),
                          itemBuilder: buildRow(snapshot.data ?? []),
                          itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                          controller: _scrollController,
                        ),
                      )
                  ),
            ),
          ],
        ));
  }
}
