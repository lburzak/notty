import 'dart:async';

import 'package:notty/model/note.dart';
import 'package:objectbox/objectbox.dart';

class NotesViewModel {
  final Box<Note> _box;
  late final Stream<Set<Note>> notesStream;
  
  List<Note> notes = [];

  NotesViewModel(Store store) : _box = Box(store) {
    notesStream = _box.query()
        .watch(triggerImmediately: true)
        .map((query) => query.find())
        .map((event) => event.toSet());

    notes = _box.query().build().find();
  }

  void addNewNote(String content) {
    if (content.isEmpty)
      return;
    
    final note = Note(content, dateCreated: DateTime.now());

    _box.put(note);
  }
  
  void deleteManyNotes(List<int> noteIds) {
    _box.removeMany(noteIds);
  }
}