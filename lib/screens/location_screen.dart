import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as webServices;
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  final bool isSelecting;

  MapScreen({
    this.isSelecting = false,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  final _selectController = TextEditingController();
  final _googleMapController = GoogleMapController;
  bool get wantKeepAlive => true;

  double latitude;
  double longitude;
  void getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData.latitude);
    print(_locationData.longitude);
    setState(() {
      latitude = _locationData.latitude;
      longitude = _locationData.longitude;
    });
  }

  LatLng _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                latitude,
                longitude,
              ),
              zoom: 16,
            ),
            // onMapCreated: (_googleMapController)=>,
            mapToolbarEnabled: true,
            markers: (_pickedLocation == null && widget.isSelecting)
                ? null
                : {
                    Marker(
                      markerId: MarkerId('m1'),
                      position: _pickedLocation ??
                          LatLng(
                            latitude,
                            longitude,
                          ),
                    ),
                  },
          ),
          Positioned(
            bottom: 90,
            left: 15,
            right: 15,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: Colors.white),
              child: TextField(
                onTap: () async {
                  webServices.Prediction p = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: "AIzaSyBOCrHhEDs11L3mvLHb2ImuJLu81HlxKok",
                    language: "en",
                    components: [
                      webServices.Component(
                          webServices.Component.country, "kgz")
                    ],
                  );
                },
                controller: _selectController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 16),
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: 'Выбрать вручную',
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 15,
            right: 15,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Далее'),
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all(Size(double.infinity, 50)),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (_) => Colors.green,
                ),
                padding: MaterialStateProperty.resolveWith<EdgeInsets>(
                    (states) => EdgeInsets.symmetric(vertical: 12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
