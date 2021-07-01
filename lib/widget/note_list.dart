import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final bool selected;

  const NoteCard({
    Key? key,
    required this.note,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: selected ? Colors.red : Colors.transparent,
              width: 2
            ),
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
                  child: DateTimeField(dateTime: note.dateCreated),
                )
              ],
            ),
          ),
        ),
      );
}

class DateTimeField extends StatelessWidget {
  final DateTime dateTime;

  const DateTimeField({Key? key, required this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String languageTag = Localizations.localeOf(context).toLanguageTag();

    String time = DateFormat.Hms(languageTag).format(dateTime);
    String date = DateFormat.yMd(languageTag).format(dateTime);

    return Text(
      date + ' ' + time,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: Color.fromARGB(255, 97, 97, 97)),
    );
  }
}

class NotesList extends StatelessWidget {
  final Stream<List<Note>> notes;
  final ScrollController _scrollController = ScrollController();

  NotesList(this.notes);

  Widget Function(BuildContext ctx, int index) buildRow(List<Note> notes) =>
      (BuildContext ctx, int index) => NoteCard(note: notes[index]);

  void scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollToBottom();
    });

    return Material(
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).colorScheme.background,
        borderRadius: new BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder<List<Note>>(
              stream: notes,
              builder: (context, snapshot) {
                return ListView.builder(
                  itemBuilder: buildRow(snapshot.data ?? []),
                  itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                  controller: _scrollController,
                );
              }),
        ));
  }
}
