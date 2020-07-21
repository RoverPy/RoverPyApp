import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in/models/theme_model.dart';
import 'package:sign_in/pages/home_page.dart';
import 'package:sign_in/utils/themes.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DarkThemeProvider _darkThemeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    _darkThemeProvider.isDarkTheme = await _darkThemeProvider.themePreference.getThemePreference();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _darkThemeProvider,
        )
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'RoverPy',
            theme: Styles.themeData(_darkThemeProvider.isDarkTheme, context),
            home: HomePage(),
          );
        },
      ),
    );
  }
}
