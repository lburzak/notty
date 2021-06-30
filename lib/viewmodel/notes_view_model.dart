import 'dart:async';

import 'package:app/models/note.dart';
import 'package:objectbox/objectbox.dart';

class NotesViewModel {
  final Box<Note> _box;
  late final Stream<List<Note>> notes;

  NotesViewModel(Store store) : _box = Box(store) {
    notes = _box.query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  void addNewNote(String content) {
    if (content.isEmpty)
      return;
    
    final note = Note(content, dateCreated: DateTime.now());

    _box.put(note);
  }
}