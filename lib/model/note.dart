import 'package:flutter/foundation.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
@immutable
class Note {
  final int id;
  final String content;
  final DateTime dateCreated;

  Note(this.content, {required this.dateCreated, this.id = 0});
}