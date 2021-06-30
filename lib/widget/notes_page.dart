import 'package:app/viewmodel/notes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'bottom_bar.dart';
import 'note_list.dart';

class NotesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _viewModel = NotesViewModel();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).primaryColor,
    body: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: NotesList(_viewModel.notes),
        ),
        BottomBar(_viewModel.addNewNote),
      ],
    ),
  );
}