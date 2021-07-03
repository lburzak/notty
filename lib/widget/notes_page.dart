import 'package:notty/viewmodel/notes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import '../objectbox.g.dart';
import 'bottom_bar.dart';
import 'note_list.dart';

class NotesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final _store;
  late final _viewModel;

  bool ready = false;

  @override
  void initState() {
    super.initState();

    _openStore().then((store) {
      _store = store;
      _viewModel = NotesViewModel(store);

      setState(() {
        ready = true;
      });
    });
  }

  Future<Store> _openStore() async {
    final dir = await getApplicationDocumentsDirectory();
    return Store(getObjectBoxModel(), directory: dir.path + '/objectbox');
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).colorScheme.primary,
    body: ready ? Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: NotesList(
              notes: _viewModel.notes,
              onDeleteNotes: (selectedIndices) {
                final selectedNotes =
                    selectedIndices.map((index) =>
                        _viewModel.noteAt(index)
                    )
                    .map((note) => note.id);

                final ids =
                  List<int>.from(selectedNotes, growable: false);

                _viewModel.deleteManyNotes(ids);
              },
          ),
        ),
        BottomBar(_viewModel.addNewNote),
      ],
    ) : CircularProgressIndicator(),
  );
}