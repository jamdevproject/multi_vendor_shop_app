import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:multi_vendor_shop_app/screens/main_screen.dart';

import 'confirmation_screen.dart';

class MapScreen extends StatefulWidget {

  const MapScreen({Key? key,}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final store = GetStorage();
  final Completer<GoogleMapController> _controller = Completer();
  LocationData? _currentPosition;
  LatLng? _latLong;
  bool _locating = false;
  geocoding.Placemark? _placeMark;



  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    _getUserLocation();
    super.initState();
  }

  Future<LocationData>_getLocationPermission()async{
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error('Service not enabled');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error('Permission Denied');
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  _getUserLocation()async{
    _currentPosition = await _getLocationPermission();
    _goToCurrentPosition(LatLng(_currentPosition!.latitude!,_currentPosition!.longitude!));
  }

  getUserAddress()async{
    List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(_latLong!.latitude, _latLong!.longitude);
    setState(() {
      _placeMark = placemarks.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height *.75,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey)
                      )
                  ),
                  child: Stack(
                    children: [
                      GoogleMap(
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        compassEnabled: false,
                        mapType: MapType.normal,
                        initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        onCameraMove: (CameraPosition position){
                          setState(() {
                            _locating = true;
                            _latLong = position.target;
                          });
                        },
                        onCameraIdle: (){
                          setState(() {
                            _locating = false;
                          });
                          getUserAddress();
                        },
                      ),
                      const Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.black12,
                              child: Icon(Icons.location_on,size: 40,),),),
                      IconButton(
                        icon: Icon(Icons.home,),
                        onPressed: (){
                          Navigator.push (
                            context,
                            MaterialPageRoute (
                              builder: (BuildContext context) => const MainScreen(
                                index: 0,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [

                  Column(
                    children: [
                      _placeMark!=null ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_locating ?'Locating...': _placeMark!.subLocality==null ? _placeMark!.locality! : _placeMark!.subLocality!,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          const SizedBox(height: 8,),
                          Row(
                            children: [
                              Text('${_placeMark!.locality!}, '),
                              Text(_placeMark!.subAdministrativeArea!=null ? '${_placeMark!.subAdministrativeArea!}, ' : ''),
                            ],
                          ),
                          Text('${_placeMark!.administrativeArea!}, ${_placeMark!.country!}, ${_placeMark!.postalCode!}')
                        ],
                      ) : Container(),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: (){
                                String _subLocal = '${_placeMark!.subLocality}, ';
                                String _locality = '${_placeMark!.locality}, ';
                                String _adminArea = '${_placeMark!.administrativeArea}, ';
                                String _subAdminArea = '${_placeMark!.subAdministrativeArea}, ';
                                String _country = '${_placeMark!.country}, ';
                                String _pin = '${_placeMark!.postalCode}, ';
                                String address = '$_subLocal$_locality$_adminArea$_subAdminArea$_country$_pin';
                                store.write('address', address);
                                Navigator.push (
                                  context,
                                  MaterialPageRoute (
                                    builder: (BuildContext context) => const ConfirmationScreen(),
                                  ),
                                );
                              },
                              child: const Text('Confirm Location'),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _goToCurrentPosition(LatLng latlng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(latlng.latitude, latlng.longitude),
            //tilt: 59.440717697143555,
            zoom: 14.4746)
    ));
  }
}