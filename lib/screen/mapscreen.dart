import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? gmCtrl;
  List<LatLng> pointedLoc = [];
  Set<Marker> markers = {};
  Set<Polyline> polyline = {};

  void _MapTappeed(LatLng point) {
    setState(() {
      if (pointedLoc.length == 2) {
        pointedLoc.clear();
        markers.clear();
        polyline.clear();
      }
      pointedLoc.add(point);

      markers.add(
        Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          infoWindow: InfoWindow(
            title: pointedLoc.length == 1 ? "Starting Point" : "Ending Point",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            pointedLoc.length == 1
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueRed,
          ),
        ),
      );

      if (pointedLoc.length == 2) {
        polyline.add(
          Polyline(
            jointType: JointType.mitered,
            polylineId: PolylineId('route'),
            points: pointedLoc,
            color: Colors.blue,
            width: 6,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Map Pointer'),
          centerTitle: true,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: GoogleMap(
          mapType: MapType.hybrid,
          onMapCreated: (controller) => gmCtrl = controller,
          onTap: _MapTappeed,
          initialCameraPosition: CameraPosition(
            target: LatLng(15.8416, 120.5157),
            zoom: 14,
          ),
          markers: markers,
          polylines: polyline,
        ),
      ),
    );
  }
}
