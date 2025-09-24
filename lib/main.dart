import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/title_page.dart';

void main() {
  runApp(MaterialApp(
    theme: AppTheme.light,   // IRCTC style
    darkTheme: AppTheme.dark, // Control Room style
    home: TitlePage(),
    debugShowCheckedModeBanner: false,
  ));
}
