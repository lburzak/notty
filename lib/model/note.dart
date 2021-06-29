import 'package:flutter/foundation.dart';

@immutable
class Note {
  final String content;
  final DateTime dateCreated;

  Note(this.content, this.dateCreated);
}