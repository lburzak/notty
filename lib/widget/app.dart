import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'notes_page.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
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
        home: NotesPage(),
        theme: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Color.fromARGB(0xff, 0x00, 0x65, 0xdb),
              background: Color.fromARGB(0xff, 0x00, 0x44, 0x94),
              secondary: Color.fromARGB(0xff, 0x19, 0x74, 0xdf)
            ),
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