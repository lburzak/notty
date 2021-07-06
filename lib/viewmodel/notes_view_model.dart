import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:notty/models/note.dart';
import 'package:objectbox/objectbox.dart';

enum DataEventType { add, remove }

@immutable
class DataEvent {
  final DataEventType type;
  final Set<int> indices;

  DataEvent.added(this.indices) : type = DataEventType.add;
  DataEvent.removed(this.indices) : type = DataEventType.remove;

  @override
  String toString() {
    return type.toString() + indices.toString();
  }
}

class NotesViewModel {
  final Box<Note> _box;
  List<Note> _cachedNotes = [];
  late final Stream<List<Note>> notes;
  final StreamController<DataEvent> _events = StreamController();

  NotesViewModel(Store store) : _box = Box(store) {
    notes = _box.query()
        .watch(triggerImmediately: true)
        .map((query) => query.find())
        .asBroadcastStream()
        ..listen((newNotes) {
          final prevNotes = _cachedNotes;
          _cachedNotes = newNotes;

          final newNotesIds = newNotes.map((note) => note.id).toSet();
          final prevNotesIds = prevNotes.map((note) => note.id).toSet();

          final addedNotesIds = newNotesIds.toSet().difference(prevNotesIds.toSet());
          final removedNotesIds = prevNotesIds.toSet().difference(newNotesIds.toSet());

          Set<int> addedNotesIndices = {};
          Set<int> removedNotesIndices = {};

          for (var i = 0; i < prevNotes.length; ++i) {
              if (addedNotesIds.contains(prevNotes[i].id))
                addedNotesIndices.add(i);

              if (removedNotesIds.contains(prevNotes[i].id))
                removedNotesIndices.add(i);
          }

          if (addedNotesIds.isNotEmpty)
            _events.add(DataEvent.added(addedNotesIds));

          if (removedNotesIds.isNotEmpty)
            _events.add(DataEvent.removed(removedNotesIds));
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