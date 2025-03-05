import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../models/location_model.dart';
import '../../models/mechanic_model.dart';
import '../mechanic/mechanic_profile_screen.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final _user = FirebaseAuth.instance.currentUser;
  Position? _currentPosition;
  String _currentAddress = '';
  bool _isLoading = true;
  StreamSubscription? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadMechanics();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen konum servislerini etkinleştirin')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Konum izni reddedildi')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Konum izinleri kalıcı olarak reddedildi')),
      );
      return;
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    _getAddressFromLatLng();
    _updateUserLocation();

    // Konum güncellemelerini dinle
    _locationSubscription = Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _updateUserLocation();
    });

    setState(() {
      _isLoading = false;
    });

    final controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  Future<void> _getAddressFromLatLng() async {
    if (_currentPosition == null) return;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}';
      });
    } catch (e) {
      print('Adres çözümleme hatası: $e');
    }
  }

  Future<void> _updateUserLocation() async {
    if (_currentPosition == null || _user == null) return;

    try {
      final locationModel = LocationModel(
        id: _user!.uid,
        userId: _user!.uid,
        type: LocationType.user,
        location: GeoPoint(_currentPosition!.latitude, _currentPosition!.longitude),
        address: _currentAddress,
        lastUpdated: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('locations')
          .doc(_user!.uid)
          .set(locationModel.toMap());
    } catch (e) {
      print('Konum güncelleme hatası: $e');
    }
  }

  Future<void> _loadMechanics() async {
    if (_currentPosition == null) return;

    final center = GeoPoint(_currentPosition!.latitude, _currentPosition!.longitude);
    const radiusInKm = 10.0;

    // Firestore'da GeoPoint ile mesafe hesaplama
    final mechanics = await FirebaseFirestore.instance
        .collection('mechanics')
        .where('isAvailable', isEqualTo: true)
        .get();

    setState(() {
      _markers.clear();
      
      // Kullanıcının konumunu ekle
      if (_currentPosition != null) {
        _markers.add(
          Marker(
            markerId: MarkerId('user'),
            position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(title: 'Konumunuz'),
          ),
        );
      }

      // Ustaların konumlarını ekle
      for (var doc in mechanics.docs) {
        final mechanic = MechanicModel.fromMap(doc.data());
        if (mechanic.location != null) {
          final distance = Geolocator.distanceBetween(
            center.latitude,
            center.longitude,
            mechanic.location!.latitude,
            mechanic.location!.longitude,
          );

          // Sadece belirtilen yarıçap içindeki ustaları göster
          if (distance <= radiusInKm * 1000) {
            _markers.add(
              Marker(
                markerId: MarkerId(mechanic.userId),
                position: LatLng(
                  mechanic.location!.latitude,
                  mechanic.location!.longitude,
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                infoWindow: InfoWindow(
                  title: mechanic.name,
                  snippet: '${mechanic.rating.toStringAsFixed(1)} ★ - ${(distance / 1000).toStringAsFixed(1)} km',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MechanicProfileScreen(
                          mechanicId: mechanic.userId,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _currentPosition == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        _currentAddress,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _loadMechanics,
              child: Icon(Icons.refresh),
              tooltip: 'Ustaları Yenile',
            ),
          ),
        ],
      ),
    );
  }
} 