import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'notes_page.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Notty',
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [
          const Locale.fromSubtags(languageCode: 'en'),
          const Locale.fromSubtags(languageCode: 'pl')
        ],
        home: NotesPage(),
        theme: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Color.fromARGB(0xff, 0x00, 0x65, 0xdb),
              background: Color.fromARGB(0xff, 0x00, 0x44, 0x94),
              secondary: Color.fromARGB(0xff, 0x19, 0x74, 0xdf),
            ),
            textTheme: Typography.blackMountainView.copyWith(
                bodyText2: TextStyle(
                    fontSize: 14.0, color: Colors.white
                )
            ).apply(
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            iconTheme: IconThemeData(
              color: Colors.white
            )
        ),
        debugShowCheckedModeBanner: false
    );
  }
}