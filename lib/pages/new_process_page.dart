import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:sign_in/models/series_model.dart';
import 'package:sign_in/pages/controls_page.dart';
import 'package:sign_in/utils/themes.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ProcessPage extends StatefulWidget {
  @override
  _ProcessPageState createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> with SingleTickerProviderStateMixin{
  final _firestore = Firestore.instance;
  final DateTime _dummyDate = DateFormat('dd-MM-yyyy').parse('21-10-2020');
  final DateTime _today = DateFormat('dd-MM-yyyy').parse(DateFormat('dd-MM-yyyy').format(DateTime.now()));
  bool showWarning;
  List<SeriesModel> data = [];
  List<Label> labels = [];
  bool loaded = false;
  AnimationController _controller;
  Animation gradientPosition;


  Future<void> getData() async {
    int count = 0;
    var lbs = [
      Label(label: 'healthy', confidence: 0.9999, url: 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/example%2F27-500x375.jpg?alt=media&token=f8a551af-cfd3-4da2-ba32-5f306e252649'),
      Label(label: 'unhealthy', confidence: 0.9999, url: 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/example%2F27-500x375.jpg?alt=media&token=f8a551af-cfd3-4da2-ba32-5f306e252649'),
      Label(label: 'healthy', confidence: 0.9999, url: 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/example%2F27-500x375.jpg?alt=media&token=f8a551af-cfd3-4da2-ba32-5f306e252649'),
      Label(label: 'unhealthy', confidence: 0.9999, url: 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/example%2F27-500x375.jpg?alt=media&token=f8a551af-cfd3-4da2-ba32-5f306e252649'),
      Label(label: 'unhealthy', confidence: 0.9999, url: 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/example%2F27-500x375.jpg?alt=media&token=f8a551af-cfd3-4da2-ba32-5f306e252649'),
      Label(label: 'healthy', confidence: 0.9999, url: 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/example%2F27-500x375.jpg?alt=media&token=f8a551af-cfd3-4da2-ba32-5f306e252649'),
      Label(label: 'unhealthy', confidence: 0.9999, url: 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/example%2F27-500x375.jpg?alt=media&token=f8a551af-cfd3-4da2-ba32-5f306e252649'),
      Label(label: 'healthy', confidence: 0.9999, url: 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/example%2F27-500x375.jpg?alt=media&token=f8a551af-cfd3-4da2-ba32-5f306e252649'),
      Label(label: 'healthy', confidence: 0.9999, url: 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/example%2F27-500x375.jpg?alt=media&token=f8a551af-cfd3-4da2-ba32-5f306e252649'),
      Label(label: 'healthy', confidence: 0.9999, url: 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/example%2F27-500x375.jpg?alt=media&token=f8a551af-cfd3-4da2-ba32-5f306e252649'),
      Label(label: 'unhealthy', confidence: 0.9999, url: 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/example%2F27-500x375.jpg?alt=media&token=f8a551af-cfd3-4da2-ba32-5f306e252649'),
      Label(label: 'unhealthy', confidence: 0.9999, url: 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/example%2F27-500x375.jpg?alt=media&token=f8a551af-cfd3-4da2-ba32-5f306e252649'),
      Label(label: 'healthy', confidence: 0.9999, url: 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/example%2F27-500x375.jpg?alt=media&token=f8a551af-cfd3-4da2-ba32-5f306e252649'),
      Label(label: 'healthy', confidence: 0.9999, url: 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/example%2F27-500x375.jpg?alt=media&token=f8a551af-cfd3-4da2-ba32-5f306e252649'),
      Label(label: 'healthy', confidence: 0.9999, url: 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/example%2F27-500x375.jpg?alt=media&token=f8a551af-cfd3-4da2-ba32-5f306e252649'),
      Label(label: 'unhealthy', confidence: 0.9999, url: 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/example%2F27-500x375.jpg?alt=media&token=f8a551af-cfd3-4da2-ba32-5f306e252649'),
    ];
    lbs.forEach((element) {
      if(element.label == 'healthy')
        count += 1;
    });
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      labels = lbs;
      data = [
        SeriesModel(label: 'healthy', count: count, color: charts.Color.fromHex(code: '#32a848')),
        SeriesModel(label: 'unhealthy', count: lbs.length - count, color: charts.Color.fromHex(code: '#a85f32')),
      ];
    });
  }

  @override
  void initState() {
    showWarning = _today != _dummyDate;
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 1500), vsync: this);
    gradientPosition = Tween<double>(
        begin: -3,
        end: 10).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Curves.linear
        )
    )..addListener(() {
      setState(() {});
    });

    _controller.repeat();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData().then((value) {
        setState(() {
          loaded = true;
        });
        _controller.dispose();
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
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Reports",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42.0,
                      fontFamily: "Calibre-Semibold",
                      letterSpacing: 1.0,
                    )
                ),
              ),
            ),
            Builder(builder: (context) {
              if(showWarning) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width-10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color.fromRGBO(3, 132, 252, 0.6),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 2*MediaQuery.of(context).size.width/3 - 32,
                                child: Text('No new data available. Head over to controls page to move rover through the field and collect data.'),
                              ),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ControlsPage()));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      boxShadow: [
                                        BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 5.0)
                                      ]
                                    ),
                                    width: MediaQuery.of(context).size.width/3 - 26,
                                      child: Text('CONTROLS PAGE', textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),)
                                  )
                              ),
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
                              child: Icon(Icons.clear, size: 15.0, color: Colors.white,)),
                        ),
                      ]
                    ),
                  ),
                );
              }
              else
                return Container();
            }),
            Card(
              child: Builder(
                builder: (context) {
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
                  }
                  else {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 240,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment(gradientPosition.value, 0),
                                end: Alignment(-1, 0),
                                colors: [Colors.black12, Colors.black26, Colors.black12],
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
                  color: Colors.white
                ),
//                height: showWarning ? ,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 5,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(43, 96, 191, 0.9),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0))
                        ),
                        child: Text("Detailed Report", style: TextStyle(fontSize: 24.0),)
                    ),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 45.0,
                                          width: 45.0,
                                          child: Image(image: NetworkImage(labels[index].url), fit: BoxFit.fill,),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(labels[index].label, style: TextStyle(color: Colors.black, fontSize: 18.0),),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text('${labels[index].confidence}', style: TextStyle(color: Colors.black12),),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          else {
                            return Container(
                              width: MediaQuery.of(context).size.width - 20,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 45.0,
                                          width: 45.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment(gradientPosition.value, 0),
                                                end: Alignment(-1, 0),
                                                colors: [Colors.black12, Colors.black26, Colors.black12],
                                              ),
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                          )
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment(gradientPosition.value, 0),
                                                end: Alignment(-1, 0),
                                                colors: [Colors.black12, Colors.black26, Colors.black12],
                                              ),
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            height: 18.0,
                                            width: 200.0,
                                          )
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Container(
                                        height: 18.0,
                                        width: 50.0,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment(gradientPosition.value, 0),
                                            end: Alignment(-1, 0),
                                            colors: [Colors.black12, Colors.black26, Colors.black12],
                                          ),
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                      )
                                    ),
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
