import 'dart:async';

import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sign_in/helpers/map_helper.dart';
import 'package:sign_in/helpers/map_marker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_in/models/user.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _mapController = Completer();

  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  /// Url image used on normal markers
  final String _markerImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/map_icon_rs.png?alt=media&token=f8fb0564-30f1-4f84-b14a-a02f8d731763';

  final String _unhealthyMarkerImageUrl = 'https://firebasestorage.googleapis.com/v0/b/roverpy-aamp.appspot.com/o/map_icon_un.png?alt=media&token=af8b990f-6cba-4932-99a8-cbc85e36d724';

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

  final List<String> _labels = [];

  /// Example marker coordinates
  final List<LatLng> _markerLocations = [
//    LatLng(41.147125, -8.611249),
//    LatLng(41.145599, -8.610691),
//    LatLng(41.145645, -8.614761),
//    LatLng(41.146775, -8.614913),
//    LatLng(41.146982, -8.615682),
//    LatLng(41.140558, -8.611530),
//    LatLng(41.138393, -8.608642),
//    LatLng(41.137860, -8.609211),
//    LatLng(41.138344, -8.611236),
//    LatLng(41.139813, -8.609381),
  ];

  /// Called when the Google Map widget is created. Updates the map loading state
  /// and inits the markers.
  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);

    setState(() {
      _isMapLoading = false;
    });

    _initMarkers();
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers() async {
    final List<MapMarker> markers = [];
    String lastUsed;

    DocumentSnapshot userDoc = await Firestore.instance.collection('users').document('HHJjcEassOW3nRJEE65tYXmTJzn2').get();
    lastUsed = userDoc.data['lastUsed'];
    print(lastUsed);

    QuerySnapshot docs = await Firestore.instance.collection('users').document('HHJjcEassOW3nRJEE65tYXmTJzn2').collection(lastUsed).getDocuments();

//    docs.documents.forEach((element) {
//      _markerLocations.add(LatLng(element.data['lat'], element.data['lng']));
//      _labels.add(element.data['label']);
//    });

    for (int i=0; i< docs.documents.length; i++) {
      print('${docs.documents[i].data['lat']} ${docs.documents[i].data['lng']}');
      if (docs.documents[i].documentID != 'report') {
        LatLng markerLocation = LatLng(docs.documents[i].data['lat'], docs.documents[i].data['lng']);
        _markerLocations.add(markerLocation);

        final BitmapDescriptor markerImage =
        await MapHelper.getMarkerImageFromUrl(docs.documents[i].data['label'] == 'healthy'? _markerImageUrl: _unhealthyMarkerImageUrl);//TODO: Filter based on label

        markers.add(
          MapMarker(
            id: i.toString(),
            position: markerLocation,
            icon: markerImage,
          ),
        );
      }
    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Map Page'),
      // ),
      body: Stack(
        children: <Widget>[
          // Google Map widget
          Opacity(
            opacity: _isMapLoading ? 0 : 1,
            child: GoogleMap(
              mapToolbarEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(41.143029, -8.611274),
                zoom: _currentZoom,
              ),
              markers: _markers,
              onMapCreated: (controller) => _onMapCreated(controller),
              onCameraMove: (position) => _updateMarkers(position.zoom),
            ),
          ),

          // Map loading indicator
          Opacity(
            opacity: _isMapLoading ? 1 : 0,
            child: Center(child: CircularProgressIndicator()),
          ),

          // Map markers loading indicator
          if (_areMarkersLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Card(
                  elevation: 2,
                  color: Colors.grey.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Loading',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab',
        onPressed: () {
          Navigator.of(context).pop();
        },
        elevation: 5.0,
        tooltip: "Go back",
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
