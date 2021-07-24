import 'package:collegeproject/Provider/SharedPref.dart';
import 'package:collegeproject/Screens/WidgetTree.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  await StorageUtil.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
      ],
      child: MaterialApp(
        supportedLocales: [Locale("en")],
        localizationsDelegates: [
          CountryLocalizations.delegate,
        ],
        theme: ThemeData(
          accentColor: Colors.purple[900],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0.5,
            titleTextStyle: GoogleFonts.montserrat(
              color: Colors.black,
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.purple[900],
            splashColor: Colors.transparent,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.purple[900]),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: WidgetTree(),
      ),
    );
  }
}
