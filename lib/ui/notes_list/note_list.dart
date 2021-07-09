import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notty/model/note.dart';
import 'package:notty/ui/common/adapter/animated_list_stream_adapter.dart';
import 'package:notty/ui/common/controller/selection_controller.dart';
import 'package:notty/viewmodel/notes_view_model.dart';
import 'package:notty/ui/common/widget/selectable_item.dart';
import 'package:provider/provider.dart';

import 'note_tile.dart';

class NotesList extends StatefulWidget {
  final NotesViewModel viewModel;
  final SelectionController selectionController;

  const NotesList(
      {Key? key,
      required this.viewModel,
      required this.selectionController})
      : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  final ScrollController _scrollController = ScrollController();
  late final AnimatedListStreamAdapter<Note> _streamAdapter =
    AnimatedListStreamAdapter(
        itemBuilder: buildRowDummy,
        stream: widget.viewModel.distinctNotes,
        onItemsAdded: scrollToBottom
    );

  Widget buildRowIndex(BuildContext ctx, int index, Animation<double> animation) =>
      SelectableItem(
        controller: widget.selectionController,
        create: (selected) => NoteTile(
          note: _streamAdapter.items[index],
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
          create: (context) => widget.selectionController,
          child: Consumer<SelectionController>(
            builder: (context, selection, child) => AnimatedList(
              key: _streamAdapter.key,
              padding: widget.selectionController.isEnabled
                  ? const EdgeInsets.all(8.0)
                  : EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 8.0,
                      left: 8.0,
                      right: 8.0,
                      bottom: 8.0),
              itemBuilder: buildRowIndex,
              initialItemCount: _streamAdapter.items.length,
              controller: _scrollController,
            ),
          ),
        ));
  }
}
