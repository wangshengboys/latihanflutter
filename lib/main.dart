import 'package:flutter/material.dart';
import 'package:flutter_pemrograman_web/pages/film.dart';
// ignore: unused_import
import 'pages/portofolio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'SFProDisplay',
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      debugShowCheckedModeBanner: false,
      //home: const PortofolioPage(),
      home: const FilmPage(),
    );
  }
}
