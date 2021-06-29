import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../model/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
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
            child: DateTimeField(
                dateTime: note.dateCreated
            ),
          )
        ],
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
          color: Color.fromARGB(255, 97, 97, 97)
      ),
    );
  }
}

class NoteList extends StatelessWidget {
  final List<Note> notes;
  final ScrollController _scrollController = ScrollController();

  NoteList(this.notes);

  Widget buildRow(BuildContext ctx, int index) => NoteCard(
      note: notes[index]
  );

  void scrollToBottom() {
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) { scrollToBottom(); });

    return Material(
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).backgroundColor,
        borderRadius: new BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemBuilder: buildRow,
            itemCount: notes.length,
            controller: _scrollController,
          ),
        )
    );
  }
}