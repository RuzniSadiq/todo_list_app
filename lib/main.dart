import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/screens/homepage.dart';
import 'package:to_do_app/screens/searchpage.dart';
import 'package:timezone/data/latest_all.dart' as tz;


void main() {
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //remove banner
        debugShowCheckedModeBanner: false,
        //add google font theme
        theme: ThemeData(
            textTheme: GoogleFonts.nunitoSansTextTheme(
          Theme.of(context).textTheme,
        ),
        ),
        //        home: Homepage(),
      home: Homepage(),
    );
  }
}
