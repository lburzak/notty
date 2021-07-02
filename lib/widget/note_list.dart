import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:notty/controller/selection_controller.dart';
import 'package:notty/widget/action_bar.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final bool selected;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const NoteCard({
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
                    child: DateTimeField(dateTime: note.dateCreated),
                  )
                ],
              ),
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

class NotesList extends StatefulWidget {
  final Stream<List<Note>> notes;

  NotesList(this.notes);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  final ScrollController _scrollController = ScrollController();
  final SelectionController _selectionController = SelectionController();
  bool _selectionMode = false;

  Widget Function(BuildContext ctx, int index) buildRow(List<Note> notes) =>
      (BuildContext ctx, int index) => Consumer<SelectionController>(
            builder: (context, selection, child) => NoteCard(
              note: notes[index],
              selected: selection.isSelected(index),
              onTap: () {
                if (_selectionMode) {
                  selection.toggle(index);
                }
              },
              onLongPress: () {
                setState(() {
                  if (!_selectionMode) _selectionMode = true;
                });
                
                selection.select(index);
              },
            ),
          );

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
        child: Column(
          children: [
            ActionBar(),
            Expanded(
              child: StreamBuilder<List<Note>>(
                  stream: widget.notes,
                  builder: (context, snapshot) => ChangeNotifierProvider(
                        create: (context) => _selectionController,
                        child: ListView.builder(
                          padding: EdgeInsets.all(8.0),
                          itemBuilder: buildRow(snapshot.data ?? []),
                          itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                          controller: _scrollController,
                        ),
                      )
                  ),
            ),
          ],
        ));
  }
}
