import 'package:objectbox/objectbox.dart';

@Entity()
class Note {
  int id;
  String content;

  @Property(type: PropertyType.date)
  final DateTime dateCreated;

  Note(this.content, {required this.dateCreated, this.id = 0});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}