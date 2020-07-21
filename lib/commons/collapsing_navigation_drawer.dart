import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in/commons/drawer_tile.dart';
import 'package:sign_in/models/models_export.dart';
import '../models/drawer_item.dart';
import 'package:sign_in/services/AuthService.dart';

import '../services/AuthService.dart';

int currSelected = 0;

class CollapsingNavDrawer extends StatefulWidget {
  @override
  _CollapsingNavDrawerState createState() => _CollapsingNavDrawerState();
}

class _CollapsingNavDrawerState extends State<CollapsingNavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      width: MediaQuery.of(context).size.width / 2,
      child: Column(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width / 2,
              color: Theme.of(context).primaryColor,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 35.0,
                  ),
                  Container(
                    height: 50.0,
                    child: Text('RoverPy',
                        style: Theme.of(context).textTheme.headline5),
                  ),
                ],
              )),
          Expanded(
            child: ListView.builder(
                itemCount: drawerList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        currSelected = index;
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => drawerList[index].goToPage),
                          (Route<dynamic> route) => false);
                    },
                    child: DrawerTile(
                      isSelected: index == currSelected,
                      iconData: drawerList[index].icon,
                      title: drawerList[index].title,
                    ),
                  );
                }),
          ),
          GestureDetector(
            onTap: () {
              AuthService().logOut();
            },
            child: Container(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.lock_open,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Log out',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ),
          SizedBox(
            height: 35.0,
          ),
          Container(
            child: Consumer<DarkThemeProvider>(
              builder: (context, themeProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.brightness_7,
                      size: 30.0,
                      color: themeProvider.isDarkTheme
                          ? Colors.grey
                          : Theme.of(context).splashColor,
                    ),
                    Switch(
                      value: themeProvider.isDarkTheme,
                      onChanged: (value) {
                        themeProvider.isDarkTheme = value;
                      },
                    ),
                    Icon(
                      Icons.brightness_2,
                      size: 30.0,
                      color: themeProvider.isDarkTheme
                          ? Theme.of(context).splashColor
                          : Colors.grey,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
