import 'package:notty/controller/selection_controller.dart';
import 'package:notty/viewmodel/notes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../objectbox.g.dart';
import 'action_bar.dart';
import 'bottom_bar.dart';
import 'note_list.dart';

class NotesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final SelectionController _selectionController = SelectionController();
  late final _store;
  late final NotesViewModel _viewModel;

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
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).colorScheme.primary,
    body: ready ? Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ChangeNotifierProvider(
          create: (context) => _selectionController,
          child: Consumer<SelectionController>(
            builder: (context, selection, child) => ActionBar(
              visible: selection.isEnabled,
              onCancel: selection.endSelection,
              onAction: () {
                final selectedNotes = selection.selectedIndices
                      .map(_viewModel.listedNotes.elementAt)
                      .map((note) => note.id);

                final ids = List<int>.from(selectedNotes, growable: false);

                _viewModel.deleteManyNotes(ids);
                selection.endSelection();
              },
            ),
          ),
        ),
        Expanded(
          child: NotesList(
              viewModel: _viewModel,
            selectionController: _selectionController,
          ),
        ),
        BottomBar(_viewModel.addNewNote),
      ],
    ) : CircularProgressIndicator(),
  );
}