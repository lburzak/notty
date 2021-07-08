import 'dart:async';

import 'package:notty/model/note.dart';
import 'package:objectbox/objectbox.dart';

class NotesViewModel {
  final Box<Note> _box;
  late final Stream<Set<Note>> distinctNotes = watchAllNotes()
      .map((event) => event.toSet());
  final List<StreamSubscription> subscriptions = [];

  List<Note> listedNotes = [];

  NotesViewModel(Store store) : _box = Box(store) {
    final notesSubscription =
      watchAllNotes().listen((notes) { listedNotes = notes; });

    subscriptions.add(notesSubscription);
  }

  Stream<List<Note>> watchAllNotes() =>
      _box.query()
          .watch(triggerImmediately: true)
          .map((query) => query.find())
          .asBroadcastStream();

  void addNewNote(String content) {
    if (content.isEmpty)
      return;
    
    final note = Note(content, dateCreated: DateTime.now());

    _box.put(note);
  }
  
  void deleteManyNotes(List<int> noteIds) {
    _box.removeMany(noteIds);
  }
  
  void dispose() {
    subscriptions
        .forEach((subscription) => subscription.cancel());
  }
}