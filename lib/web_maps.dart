import 'dart:html';
import 'dart:ui' as ui;

import 'package:cross_maps/cross_maps.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';

class WebMaps implements CrossMaps {
  static final WebMaps _instance = WebMaps._WebMaps();

  static WebMaps get instance => _instance;

  GMap _map;
  List<Marker> markers;

  WebMaps._WebMaps() {
    markers = <Marker>[];
  }

//  @override
//  void addMarker(double lat, double lng, String title) {
//    Marker marker = Marker(
//      MarkerOptions(
//        draggable: true,
//      ),
//    ).setLngLat(LngLat(lng, lat)).addTo(_map);
//    markers.add(marker);
//  }
//
//  @override
//  Widget getMaps(double lat, double lng, String title,
//      {Function onTap,
//      List<double> poly_lats,
//      List<double> poly_lngs,
//      String mapbox}) {
//    Mapbox.accessToken = mapbox;
//
//    _map = MapboxMap(
//      MapOptions(
//        container: 'map',
//        style: 'mapbox://styles/mapbox/dark-v10',
//        center: LngLat(lng, lat),
//        zoom: 12,
//      ),
//    );
//    //addMarker(lat, lng, title);
//  }
//
//  @override
//  void setPolyline(List<double> lats, List<double> lngs) {
//    // TODO: implement setPolyline
//  }

  @override
  Widget getMaps(double lat, double lng, String title,
      {Function onTap, List<double> poly_lats, List<double> poly_lngs}) {
    String htmlId = "7";
    final mapOptions = MapOptions()
      ..zoom = 8
      ..center = LatLng(lat, lng)
      ..mapTypeId = MapTypeId.TERRAIN
      ..backgroundColor = '#ffffff';

// ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      var elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';
      _map = GMap(elem, mapOptions);
      _map.onClick.listen((event) {
        onTap(event.latLng.lat, event.latLng.lng);
      });
      addMarker(lat, lng, title);
      setPolyline(poly_lats, poly_lngs);
      return elem;
    });
    return HtmlElementView(viewType: htmlId);
  }

  @override
  void addMarker(double lat, double lng, String title) {
    String htmlId = "7";
    final mapOptions = MapOptions()
      ..zoom = 8
      ..center = LatLng(lat, lng)
      ..mapTypeId = MapTypeId.TERRAIN
      ..backgroundColor = '#ffffff';
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      var elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';
      _map = GMap(elem, mapOptions);
      Marker marker = Marker(MarkerOptions()
        ..position = LatLng(lat, lng)
        ..map = _map
        ..title = "Posizione: $title"
        ..clickable = true
        ..draggable = true);
      markers.add(marker);
      return elem;
    });
  }

  void clearMarkers() {
    for (final m in markers) {
      m.map = null;
    }
    markers.clear();
  }

  @override
  void setPolyline(List<double> lats, List<double> lngs) {
    List<LatLng> path = [];
    if ((lats != null) && (lngs != null)) {
      for (int i = 0; i < lats.length; i++) {
        path.add(LatLng(lats[i], lngs[i]));
      }
      Polyline(PolylineOptions()
        ..map = _map
        ..path = path);
    }
  }
}

CrossMaps getCrossMaps() => WebMaps.instance;
