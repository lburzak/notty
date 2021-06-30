import 'package:objectbox/objectbox.dart';

@Entity()
class Note {
  int id;
  String content;

  @Property(type: PropertyType.date)
  final DateTime dateCreated;

  Note(this.content, {required this.dateCreated, this.id = 0});
}