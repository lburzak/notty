import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'bottom_bar.dart';
import '../model/note.dart';
import 'note_list.dart';

class NotesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> _notes = [];

  void addNewNote(String name) {
    setState(() {
      if (name.isNotEmpty)
        _notes.add(
            Note(name, DateTime.now())
        );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).primaryColor,
    body: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: NoteList(_notes),
        ),
        BottomBar(addNewNote),
      ],
    ),
  );
}