import 'package:flutter/material.dart';
import 'package:pokldex/screens/home_page.dart';
import 'package:pokldex/util/custom_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokldex',
      themeMode: ThemeMode.system,
      theme: CustomTheme.light,
      darkTheme: CustomTheme.dark,
      home: const HomePage(title: 'Pokldex'),
    );
  }
}
