import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:notty/models/note.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final bool selected;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const NoteTile({
    Key? key,
    required this.note,
    this.selected = false,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: selected ? Colors.red : Colors.transparent, width: 2),
              borderRadius: BorderRadius.circular(6)),
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        note.content,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: _DateTimeField(dateTime: note.dateCreated),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}

class _DateTimeField extends StatelessWidget {
  final DateTime dateTime;

  const _DateTimeField({Key? key, required this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String languageTag = Localizations.localeOf(context).toLanguageTag();

    String time = DateFormat.Hms(languageTag).format(dateTime);
    String date = DateFormat.yMd(languageTag).format(dateTime);

    return Text(
      [date, time].join(' '),
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: Color.fromARGB(255, 97, 97, 97)),
    );
  }
}
