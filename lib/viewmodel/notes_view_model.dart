import 'dart:async';

import 'package:notty/models/note.dart';
import 'package:objectbox/objectbox.dart';

class NotesViewModel {
  final Box<Note> _box;
  List<Note> _cachedNotes = [];
  late final Stream<List<Note>> notes;

  NotesViewModel(Store store) : _box = Box(store) {
    notes = _box.query()
        .watch(triggerImmediately: true)
        .map((query) => query.find())
        .asBroadcastStream()
        ..listen((notes) { 
          _cachedNotes = notes;
        });
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

  Note noteAt(int index) => _cachedNotes[index];
}