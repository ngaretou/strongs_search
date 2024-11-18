// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import

import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'theme.dart';
import 'widgets/body.dart';
import 'widgets/nav.dart';
import '../widgets/help_pane.dart';
import 'providers/nav_controller.dart';

late Box userPrefsBox;

void main() async {
  await Hive.initFlutter();
  userPrefsBox = await Hive.openBox('userPrefs');
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (ctx) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (ctx) => HelpPaneController(),
      ),
      ChangeNotifierProvider(
        create: (ctx) => NavController(),
      ),
      ChangeNotifierProvider(
        create: (ctx) => PageTracker(),
      ),
    ], child: const MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: true);
    //
    themeProvider.themeInit();

    return MaterialApp(
      theme: themeProvider.currentTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("SAB menu transliteration helper"),
          automaticallyImplyLeading: true,
        ),
        //The main view of the app is three columns: the nav bar, the main workign area, and help pane
        body: const Row(
          children: [NavBar(), Body(), HelpPane()],
        ),
      ),
    );
  }
}
