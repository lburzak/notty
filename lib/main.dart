import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: new NotesPage(),
        theme: ThemeData(
          primaryColor: Color.fromARGB(0xff, 0x00, 0x65, 0xdb),
          backgroundColor: Color.fromARGB(0xff, 0x00, 0x44, 0x94),
          accentColor: Color.fromARGB(0xff, 0x19, 0x74, 0xdf)
        ),
        debugShowCheckedModeBanner: false
    );
  }
}

class NotesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<String> _notes = [for (var i in List<int>.generate(20, (i) => i + 1)) '$i'];

  void addNewNote(String name) {
    setState(() {
      _notes.add(name);
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
          Container(
            height: 50,
            child: BottomBar(addNewNote),
          )
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

  const NoteInputBox({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
    elevation: 4,
    color: Theme.of(context).accentColor,
    borderRadius: BorderRadius.circular(32),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 42,
        child: Center(
          child: TextField(
            onChanged: onChanged,
            maxLines: 1,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
            ),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0.0),
                isDense: true,
                border: InputBorder.none
            ),
          ),
        ),
      ),
    ),
  );
}

class BottomBar extends StatefulWidget {
  final void Function(String text)? onNewNote;

  BottomBar(this.onNewNote);

  @override
  State createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  String? _newNoteContent;

  void changeNewNote(String newContent) {
    setState(() {
      _newNoteContent = newContent;
    });
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
    child: Row(
      children: [
        BottomBarButton(icon: Icons.arrow_upward),
        Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: NoteInputBox(onChanged: changeNewNote),
            )
        ),
        BottomBarButton(
            icon: Icons.send,
            onPressed: () {
              widget.onNewNote!(_newNoteContent!);
            }),
      ],
    ),
  );
}

class NoteList extends StatelessWidget {
  final List<String> notes;

  NoteList(this.notes);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      borderRadius: new BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20)
      ),
      child: ListView(
        children: [for (var note in notes) Note(note)],
      ),
    );
  }
}

class Note extends StatelessWidget {
  final String content;

  Note(this.content);

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(this.content),
    ),
  );
}