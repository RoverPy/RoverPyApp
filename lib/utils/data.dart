import 'package:flutter/cupertino.dart';
import 'package:sign_in/pages/about.dart';
import 'package:sign_in/pages/process_page.dart';
import 'package:sign_in/pages/profile.dart';
// import 'package:sign_in/pages/tf.dart';

List<String> images = [
  "assets/about.gif",
  "assets/user.gif",
  "assets/Reports.gif",
  "assets/map.gif",
];

List<String> title = [
  "About",
  "User Profile",
  "Reports",
  "Map",
];

List<Widget> pushTo = [
  AboutUs(),
  ProfilePage(),
  ProcessingPage(),
  AboutUs(),
];
