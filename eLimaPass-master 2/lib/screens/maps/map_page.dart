import 'dart:async';

import 'package:elimapass/models/entities/Paradero.dart';
import 'package:elimapass/models/entities/Ruta.dart';
import 'package:elimapass/services/map_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import '../../widgets/loading_foreground.dart';

class MapPage extends StatefulWidget {
  final Ruta ruta;
  const MapPage({super.key, required this.ruta});

  @override
  State<StatefulWidget> createState() {
    return _MapTestState();
  }
}

class _MapTestState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapController;
  LatLng? _currentPosition;
  LocationPermission? permission;
  final MapService _mapService = MapService();
  Set<Marker> paraderos = {};
  List<LatLng> puntos = [];
  List<LatLng> polylineCoordinates = [];
  bool ida = true;
  List<Paradero> _allParaderos = [];
  List<Paradero> _currParaderos = [];
  int _currentParaderoIndex = 0;
  late String _mapStyleString;
  final brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  getPolyLinePoints() async {
    polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: 'AIzaSyDM5-MwvTY2zaGg8wwMBmPZlST5dMHXAN0',
      request: PolylineRequest(
          origin: PointLatLng(puntos.first.latitude, puntos.first.longitude),
          destination: PointLatLng(puntos.last.latitude, puntos.last.longitude),
          mode: TravelMode.transit),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  getLocation() async {
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(accuracy: LocationAccuracy.high));
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
    });
  }

  getParaderos() async {
    List<Paradero> _paraderos = await _mapService.getParaderos(widget.ruta.id);
    setState(() {
      _allParaderos = _paraderos;
    });
    setParaderosOnScreen(_allParaderos);
  }

  setParaderosOnScreen(List<Paradero> _paraderos) {
    Set<Marker> _tempParaderos = {};
    List<LatLng> _tempPuntos = [];
    List<Paradero> _paraderosToPlace;

    if (ida) {
      _paraderosToPlace =
          _paraderos.where((Paradero paradero) => paradero.sentidoIda).toList();
    } else {
      _paraderosToPlace = _paraderos
          .where((Paradero paradero) => !paradero.sentidoIda)
          .toList();
    }

    for (Paradero paradero in _paraderosToPlace) {
      LatLng _position = LatLng(
        double.parse(paradero.latitud),
        double.parse(paradero.longitud),
      );

      Marker _marker = Marker(
          markerId: MarkerId(paradero.id),
          position: _position,
          infoWindow: InfoWindow(
            title: paradero.nombre,
          ),
          onTap: () {
            setState(() {
              _currentParaderoIndex = _paraderosToPlace.indexOf(paradero);
            });
            _moveCameraToPosition(_position);
          });

      _tempParaderos.add(_marker);
      _tempPuntos.add(_position);
    }

    setState(() {
      paraderos = _tempParaderos;
      puntos = _tempPuntos;
      _currParaderos = _paraderosToPlace;
      _currentParaderoIndex = 0;
    });

    getPolyLinePoints();
  }

  void _moveCameraToPosition(LatLng position) {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: position,
        zoom: 15.0,
      ),
    ));
  }

  @override
  void initState() {
    if (brightness == Brightness.light) {
      rootBundle.loadString('assets/map_styles/light_map.json').then((string) {
        _mapStyleString = string;
      });
    } else {
      rootBundle.loadString('assets/map_styles/dark_map.json').then((string) {
        _mapStyleString = string;
      });
    }

    super.initState();
    _initializeMapRenderer();
    getLocation();
    getParaderos();
  }

  void _initializeMapRenderer() {
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (puntos.isNotEmpty) {
      _moveCameraToPosition(puntos.first);
      _selectMarker(_currParaderos.first.id);
    }
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  void _goToNextParadero() {
    setState(() {
      if (_currentParaderoIndex < _currParaderos.length - 1) {
        _currentParaderoIndex++;
      } else {
        _currentParaderoIndex = 0;
      }
    });

    Paradero nextParadero = _currParaderos[_currentParaderoIndex];
    _moveCameraToPosition(
      LatLng(
        double.parse(nextParadero.latitud),
        double.parse(nextParadero.longitud),
      ),
    );
    _selectMarker(nextParadero.id);
  }

  void _goToPreviousParadero() {
    setState(() {
      if (_currentParaderoIndex > 0) {
        _currentParaderoIndex--;
      } else {
        _currentParaderoIndex = _currParaderos.length - 1;
      }
    });

    Paradero previousParadero = _currParaderos[_currentParaderoIndex];
    _moveCameraToPosition(
      LatLng(
        double.parse(previousParadero.latitud),
        double.parse(previousParadero.longitud),
      ),
    );
    _selectMarker(previousParadero.id);
  }

  void _selectMarker(String markerId) {
    mapController?.showMarkerInfoWindow(MarkerId(markerId));
  }

  @override
  Widget build(BuildContext context) {
    if (paraderos.isEmpty || _currentPosition == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_outlined,
            size: 35,
          ),
          color: Colors.white,
        ),
        backgroundColor: const Color(0XFF405f90),
        title: Text(
          "Paraderos Línea ${widget.ruta.nombre}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  style: _mapStyleString,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 15.0,
                  ),
                  markers: paraderos,
                  polylines: {
                    Polyline(
                        polylineId: PolylineId("route"),
                        points: polylineCoordinates,
                        color: Colors.blueAccent,
                        width: 4),
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  zoomControlsEnabled: true,
                  compassEnabled: true,
                ),
              ),
              bottomNavigator(),
            ],
          ),
          Positioned(
            top: 12,
            right: 60,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.rectangle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.swap_horiz,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    ida = !ida;
                  });
                  setParaderosOnScreen(_allParaderos);
                  _moveCameraToPosition(puntos.first);
                },
              ),
            ),
          ),
          if (paraderos.isEmpty) const LoadingForeground(),
        ],
      ),
    );
  }

  Widget bottomNavigator() {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          _goToNextParadero();
        } else if (details.primaryVelocity! > 0) {
          _goToPreviousParadero();
        }
      },
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: ida ? _goToPreviousParadero : _goToNextParadero,
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _currParaderos[_currentParaderoIndex].nombre,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      'Lat: ${_currParaderos[_currentParaderoIndex].latitud}, '
                      'Long: ${_currParaderos[_currentParaderoIndex].longitud}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: ida ? _goToNextParadero : _goToPreviousParadero,
            ),
          ],
        ),
      ),
    );
  }
}
