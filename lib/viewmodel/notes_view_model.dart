import 'package:app/model/note.dart';

class NotesViewModel {
  List<Note> notes = [];

  void addNewNote(String content) {
    if (content.isEmpty)
      return;
    
    final note = Note(content, dateCreated: DateTime.now());
    notes.add(note);
  }
}