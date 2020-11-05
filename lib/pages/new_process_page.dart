import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:quiver/async.dart';
import 'package:sign_in/models/series_model.dart';
import 'package:sign_in/pages/controls_page.dart';
import 'package:sign_in/pages/tf.dart';
import 'package:sign_in/utils/customIcons.dart';
import 'package:sign_in/utils/themes.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ProcessPage extends StatefulWidget {
  @override
  _ProcessPageState createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage>
    with TickerProviderStateMixin {
  final _firestore = Firestore.instance;
  final DateTime _today = DateFormat('dd-MM-yyyy')
      .parse(DateFormat('dd-MM-yyyy').format(DateTime.now()));
  DateTime _lastUsed;
  bool showWarning = false;
  List<SeriesModel> data = [];
  List<Label> labels = [];
  bool loaded = false;
  AnimationController _controller;
  Animation gradientPosition;
  TFLite model = TFLite();

  Future<void> getData() async {
    _controller = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    gradientPosition = Tween<double>(begin: -3, end: 10)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear))
          ..addListener(() {
            setState(() {});
          });

    _controller.repeat();
    int count = 0;
    List<Label> lbs = [];
    DocumentSnapshot doc = await _firestore
        .collection('users')
        .document('HHJjcEassOW3nRJEE65tYXmTJzn2')
        .collection('${DateFormat('dd-MM-yyyy').format(_lastUsed)}')
        .document('report')
        .get();
    var processed = doc.data['processed'];
    QuerySnapshot images = await _firestore
        .collection('users')
        .document('HHJjcEassOW3nRJEE65tYXmTJzn2')
        .collection('${DateFormat('dd-MM-yyyy').format(_lastUsed)}')
        .getDocuments();
    if (processed) {
      images.documents.forEach((element) {
        if (element.documentID != "report") {
          lbs.add(Label(
              url: element.data['img'],
              label: element.data['label'],
              confidence: element.data['confidence']));
        }
      });
    } else {
      await model.loadModel();
      if (model.modelLoaded) {
        await Future.forEach(images.documents, (element) async {
          if (element.documentID != "report") {
            List<Map> lb = await model.getImageLabels(element.data['img']);
            lbs.add(Label(
              url: element.data['img'],
              label: lb[0]['label'].substring(2),
              confidence: lb[0]['confidence'],
            ));
          }
        });
      }
    }
    lbs.forEach((element) {
      if (element.label == 'healthy') count += 1;
    });
    setState(() {
      labels = lbs;
      data = [
        SeriesModel(
            label: 'healthy',
            count: count,
            color: charts.Color.fromHex(code: '#32a848')),
        SeriesModel(
            label: 'unhealthy',
            count: lbs.length - count,
            color: charts.Color.fromHex(code: '#a85f32')),
      ];
    });
  }

  modelChanged() async {
    setState(() {
      loaded = false;
    });
    _controller = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    gradientPosition = Tween<double>(begin: -3, end: 10)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear))
          ..addListener(() {
            setState(() {});
          });

    _controller.repeat();

    var count = 0;
    List<Label> lbs = [];
    await model.loadModel();
    if (model.modelLoaded) {
      await Future.forEach(labels, (element) async {
        List<Map> lb = await model.getImageLabels(element.url);
        lbs.add(Label(
          url: element.url,
          label: lb[0]['label'].substring(2),
          confidence: lb[0]['confidence'],
        ));
      });
      lbs.forEach((element) {
        if (element.label == 'healthy') count += 1;
      });
      setState(() {
        labels = lbs;
        data = [
          SeriesModel(
              label: 'healthy',
              count: count,
              color: charts.Color.fromHex(code: '#32a848')),
          SeriesModel(
              label: 'unhealthy',
              count: lbs.length - count,
              color: charts.Color.fromHex(code: '#a85f32')),
        ];
        loaded = true;
      });
    }
  }

  Future<void> setShowWarning() async {
    DocumentSnapshot userDoc = await _firestore
        .collection('users')
        .document('HHJjcEassOW3nRJEE65tYXmTJzn2')
        .get();
    setState(() {
      _lastUsed = DateFormat('dd-MM-yyyy').parse(userDoc.data['lastUsed']);
      showWarning = _lastUsed != _today;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setShowWarning().then((value) {
        getData().then((value) {
          setState(() {
            loaded = true;
          });
          _controller.dispose();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: Styles.background,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Reports",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42.0,
                        fontFamily: "Calibre-Semibold",
                        letterSpacing: 1.0,
                      )),
                  Builder(
                    builder: (context) {
                      return PopupMenuButton<String>(
                          icon: Icon(
                            CustomIcons.option,
                            size: 12.0,
                            color: Colors.white,
                          ),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                child: Text('Health Detection'),
                                value: 'TomatoModel',
                              ),
                              PopupMenuItem(
                                child: Text('Flower Detection'),
                                value: 'Flower_Float',
                              )
                            ];
                          },
                          onSelected: (value) async {
                            model.setModel = value;
                            await modelChanged();
                          });
                    },
                  ),
                ],
              ),
            ),
            Builder(builder: (context) {
              if (showWarning) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color.fromRGBO(3, 132, 252, 0.6),
                    ),
                    child: Stack(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 2 * MediaQuery.of(context).size.width / 3 -
                                  32,
                              child: Text(
                                  'No new data available. Head over to controls page to move rover through the field and collect data.'),
                            ),
                            FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ControlsPage()));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              blurRadius: 5.0)
                                        ]),
                                    width:
                                        MediaQuery.of(context).size.width / 3 -
                                            26,
                                    child: Text(
                                      'CONTROLS PAGE',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ))),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 8,
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                showWarning = false;
                              });
                            },
                            child: Icon(
                              Icons.clear,
                              size: 15.0,
                              color: Colors.white,
                            )),
                      ),
                    ]),
                  ),
                );
              } else
                return Container();
            }),
            Card(
              child: Builder(builder: (context) {
                if (loaded) {
                  var series = [
                    charts.Series(
                      id: 'report',
                      domainFn: (SeriesModel item, _) => item.label,
                      measureFn: (SeriesModel item, _) => item.count,
                      colorFn: (SeriesModel item, _) => item.color,
                      data: data,
                    )
                  ];
                  var chart = charts.BarChart(
                    series,
                    animate: true,
                  );
                  return Container(
                    height: 250,
                    child: chart,
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 240,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(
                              gradientPosition == null
                                  ? -3
                                  : gradientPosition.value,
                              0),
                          end: Alignment(-1, 0),
                          colors: [
                            Colors.black12,
                            Colors.black26,
                            Colors.black12
                          ],
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  );
                }
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white),
//                height: showWarning ? ,
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width - 5,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(43, 96, 191, 0.9),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3.0),
                          child: Text(
                            "Detailed Report",
                            style: TextStyle(fontSize: 24.0),
                          ),
                        )),
                    Container(
                      height: 300,
                      child: ListView.builder(
                        itemCount: loaded ? labels.length : 10,
                        itemBuilder: (context, index) {
                          if (loaded) {
                            return Container(
                              width: MediaQuery.of(context).size.width - 20,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 45.0,
                                          width: 45.0,
                                          child: Image(
                                            image:
                                                NetworkImage(labels[index].url),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            labels[index].label,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        '${labels[index].confidence}',
                                        style: TextStyle(color: Colors.black12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              width: MediaQuery.of(context).size.width - 20,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            height: 45.0,
                                            width: 45.0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment(
                                                      gradientPosition == null
                                                          ? -3
                                                          : gradientPosition
                                                              .value,
                                                      0),
                                                  end: Alignment(-1, 0),
                                                  colors: [
                                                    Colors.black12,
                                                    Colors.black26,
                                                    Colors.black12
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment(
                                                      gradientPosition == null
                                                          ? -3
                                                          : gradientPosition
                                                              .value,
                                                      0),
                                                  end: Alignment(-1, 0),
                                                  colors: [
                                                    Colors.black12,
                                                    Colors.black26,
                                                    Colors.black12
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              height: 18.0,
                                              width: 200.0,
                                            )),
                                      ],
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                          height: 18.0,
                                          width: 50.0,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment(
                                                  gradientPosition == null
                                                      ? -3
                                                      : gradientPosition.value,
                                                  0),
                                              end: Alignment(-1, 0),
                                              colors: [
                                                Colors.black12,
                                                Colors.black26,
                                                Colors.black12
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
