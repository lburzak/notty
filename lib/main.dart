
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _localeInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pl_PL').then((value) => {
      setState(() {
        _localeInitialized = true;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return _localeInitialized ? MaterialApp(
        home: new NotesPage(),
        theme: ThemeData(
          primaryColor: Color.fromARGB(0xff, 0x00, 0x65, 0xdb),
          backgroundColor: Color.fromARGB(0xff, 0x00, 0x44, 0x94),
          accentColor: Color.fromARGB(0xff, 0x19, 0x74, 0xdf),
          textTheme: Typography.blackMountainView.copyWith(
            bodyText2: TextStyle(
              fontSize: 14.0, color: Colors.white
            )
          ).apply(
            fontFamily: GoogleFonts.poppins().fontFamily,
          )
        ),
        debugShowCheckedModeBanner: false
    ) : CircularProgressIndicator();
  }
}

class NotesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> _notes = [];

  void addNewNote(String name) {
    setState(() {
      if (name.isNotEmpty)
        _notes.add(
          Note(name, DateTime.now())
        );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: NoteList(_notes),
          ),
          BottomBar(addNewNote),
        ],
      ),
    );
}

class BottomBarButton extends StatelessWidget {
  BottomBarButton({Key? key, required this.icon, this.onPressed}) : super(key: key);

  final void Function()? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: 32,
    child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(
          this.icon,
          color: Colors.white,
        )
    ),
  );
}

class NoteInputBox extends StatelessWidget {
  final void Function(String text)? onChanged;
  final void Function(String text)? onSubmitted;
  final TextEditingController? controller;
  final String text;
  final bool multiline;

  NoteInputBox({Key? key, this.onChanged, this.onSubmitted, this.text = "", this.multiline = false, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Theme.of(context).accentColor,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          maxLines: multiline ? 10 : 1,
          style: Theme.of(context).textTheme.bodyText2,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0.0),
              isDense: true,
              border: InputBorder.none
          ),
        ),
      ),
    );
  }
}

class BottomBar extends StatefulWidget {
  final void Function(String text)? onNewNote;

  BottomBar(this.onNewNote);

  @override
  State createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool _isExpanded = false;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _inputController.addListener(() {
      _inputController.value = _inputController.value.copyWith(
          text: _inputController.text,
          selection: TextSelection.collapsed(offset: _inputController.text.length)
      );
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
  
  void _submitNewNote(String content) {
    widget.onNewNote!(content);

    setState(() {
      _inputController.clear();
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: Duration(milliseconds: 100),
    height: _isExpanded ? 200 : 50,
    child: Padding(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomBarButton(
                icon: _isExpanded ? Icons.arrow_downward : Icons.arrow_upward,
                onPressed: _toggleExpanded
              ),
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: NoteInputBox(
                      controller: _inputController,
                      multiline: _isExpanded,
                      onSubmitted: _submitNewNote),
                )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomBarButton(
                  icon: Icons.send,
                  onPressed: () {
                    _submitNewNote(_inputController.text);
                  }),
            ),
          ],
        ),
    )
  );
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

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              note.content,
              style: Theme.of(context).textTheme.bodyText1,
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

@immutable
class Note {
  final String content;
  final DateTime dateCreated;

  Note(this.content, this.dateCreated);
}