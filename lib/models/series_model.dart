import 'package:charts_flutter/flutter.dart' as charts;

class SeriesModel {
  final String label;
  final int count;
  final charts.Color color;

  SeriesModel({this.label, this.count, this.color});
}

class Label {
  final String label;
  final String url;
  final double confidence;

  Label({this.label, this.url, this.confidence});
}