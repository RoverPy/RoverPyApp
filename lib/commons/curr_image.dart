import 'package:flutter/cupertino.dart';

class CurrImage extends ChangeNotifier{
  String url;

  CurrImage({this.url});

  void setUrl(String url) {
    this.url = url;
    notifyListeners();
  }
}