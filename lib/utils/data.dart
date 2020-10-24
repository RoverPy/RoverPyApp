import 'package:flutter/cupertino.dart';
import 'package:sign_in/pages/about.dart';
//import 'package:sign_in/pages/process_page.dart';
import 'package:sign_in/pages/tf.dart';
import 'package:sign_in/pages/map_page.dart';
import 'package:sign_in/pages/video_page.dart';
import 'package:sign_in/pages/profile.dart';
import 'package:sign_in/pages/new_process_page.dart';

List<String> images = [
  "assets/about.gif",
  "assets/profileCard.jpg",
  "assets/Reports.gif",
  "assets/locate.jpg",
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
  ProcessPage(),
  MapPage(),
];
