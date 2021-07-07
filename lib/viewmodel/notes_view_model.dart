import 'dart:async';

import 'package:notty/model/note.dart';
import 'package:objectbox/objectbox.dart';

abstract class DataEvent {
  final Set<int> indices;

  DataEvent(this.indices);
}

class DataRemovedEvent <T> extends DataEvent {
  final List<T> snapshot;

  DataRemovedEvent(Set<int> indices, this.snapshot) : super(indices);

  @override
  String toString() {
    return "DataRemovedEvent$indices";
  }
}

class DataAddedEvent extends DataEvent {
  DataAddedEvent(Set<int> indices) : super(indices);

  @override
  String toString() {
    return "DataAddedEvent$indices";
  }
}

class NotesViewModel {
  final Box<Note> _box;
  late final Stream<Set<Note>> notesStream;
  
  List<Note> notes = [];
  
  final StreamController<DataEvent> _events = StreamController();

  Stream<DataEvent> get events => _events.stream;

  NotesViewModel(Store store) : _box = Box(store) {
    notesStream = _box.query()
        .watch(triggerImmediately: true)
        .map((query) => query.find())
        .map((event) => event.toSet());

    notes = _box.query().build().find();

    _box.query()
        .watch(triggerImmediately: true)
        .map((query) => query.find())
        .asBroadcastStream()
        ..listen((newNotes) {
          final prevNotes = notes;
          notes = newNotes;

          final newNotesIds = newNotes.map((note) => note.id).toSet();
          final prevNotesIds = prevNotes.map((note) => note.id).toSet();

          final addedNotesIds = newNotesIds.toSet().difference(prevNotesIds.toSet());
          final removedNotesIds = prevNotesIds.toSet().difference(newNotesIds.toSet());

          Set<int> addedNotesIndices = {};
          Set<int> removedNotesIndices = {};

          for (var i = 0; i < prevNotes.length; ++i) {
              if (removedNotesIds.contains(prevNotes[i].id))
                removedNotesIndices.add(i);
          }

          for (var i = 0; i < newNotes.length; ++i) {
              if (addedNotesIds.contains(newNotes[i].id))
                addedNotesIndices.add(i);
          }

          if (addedNotesIndices.isNotEmpty)
            _events.add(DataAddedEvent(addedNotesIndices));

          if (removedNotesIndices.isNotEmpty)
            _events.add(DataRemovedEvent(removedNotesIndices, prevNotes));
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
}