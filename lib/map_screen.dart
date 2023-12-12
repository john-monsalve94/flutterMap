import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutternap2/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  
  List listOfPoints = [];

  
  List<LatLng> points = [];

  
  getCoordinates() async {
    
    var response = await http.get(getRouteUrl("1.243344,6.145332",
        '1.2160116523406839,6.125231015668568'));
    setState(() {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        listOfPoints = data['features'][0]['geometry']['coordinates'];
        points = listOfPoints
            .map((p) => LatLng(p[1].toDouble(), p[0].toDouble()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          zoom: 15,
          center: LatLng(2.44177737496772, -76.60633522914559)
        ),
        children: [
       
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          
          MarkerLayer(
            markers: [
            
              Marker(
                point: LatLng(2.4422295991846688, -76.6027732565465),
                width: 80,
                height: 80,
                builder: (context) => IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.location_on),
                  color: Colors.green,
                  iconSize: 45,
                ),
              ),
             
              Marker(
                point: LatLng(2.4380056669407404, -76.60942228864768),
                width: 80,
                height: 80,
                builder: (context) => IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.location_on),
                  color: Colors.red,
                  iconSize: 45,
                ),
              ),
            ],
          ),

         
          PolylineLayer(
            polylineCulling: false,
            polylines: [
              Polyline(
                  points: points, color: Colors.black, strokeWidth: 5),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () => getCoordinates(),
        child: const Icon( Icons.route,
          color: Colors.white,
        ),
      ),
    );
  }
}
