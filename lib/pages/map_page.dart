import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              title: Text('Map'),
              centerTitle: true,
            ),
            body: FlutterMap(
              options: MapOptions(
                  maxZoom: 18.0,
                  zoom: 17.0,
                  minZoom: 15.0,
                  center: LatLng(41.3070, 69.2834)),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(markers: [
                  Marker(
                      width: 24.0,
                      height: 24.0,
                      point: LatLng(41.3070, 69.2834),
                      builder: (context) => Container(
                            child: IconButton(
                              icon: Icon(FontAwesomeIcons.mapMarkerAlt),
                              color: Colors.red[600],
                              iconSize: 24.0,
                              onPressed: () {},
                            ),
                          ))
                ])
              ],
            ),
          )
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Map'),
            ),
            child: FlutterMap(
              options: MapOptions(
                  maxZoom: 18.0,
                  zoom: 17.0,
                  minZoom: 15.0,
                  center: LatLng(41.3070, 69.2834)),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(markers: [
                  Marker(
                      width: 24.0,
                      height: 24.0,
                      point: LatLng(41.3070, 69.2834),
                      builder: (context) => Container(
                            child: IconButton(
                              icon: Icon(FontAwesomeIcons.mapMarkerAlt),
                              color: Colors.red[600],
                              iconSize: 24.0,
                              onPressed: () {},
                            ),
                          ))
                ])
              ],
            ),
          );
  }
}
