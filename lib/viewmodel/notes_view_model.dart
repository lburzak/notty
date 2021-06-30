import 'dart:async';

import 'package:app/model/note.dart';

class NotesViewModel {
  List<Note> _notes = [];
  StreamController<List<Note>> _notesStreamController = StreamController(sync: true);

  Stream<List<Note>> get notes => _notesStreamController.stream;

  void addNewNote(String content) {
    if (content.isEmpty)
      return;
    
    final note = Note(content, dateCreated: DateTime.now());

    _notes.add(note);
    _notesStreamController.add(_notes);
  }
}