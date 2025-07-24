import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../widgets/location_info_widget.dart' as info_widget;
import 'dart:async';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with WidgetsBindingObserver {

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _mapReady = false;
  Timer? _debounceTimer;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  // Camera position cache to avoid unnecessary updates
  LatLng? _lastPosition;
    Future<void> _searchAndGo(String query) async {
    setState(() => _isSearching = true);
    try {
      final locations = await GeocodingPlatform.instance!.locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final target = LatLng(loc.latitude, loc.longitude);
        _mapController?.animateCamera(CameraUpdate.newLatLng(target));
        setState(() {
          _markers = {
            Marker(
              markerId: const MarkerId('search_location'),
              position: target,
              infoWindow: InfoWindow(title: query),
            ),
          };
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se encontró la dirección')),
      );
    }
    setState(() => _isSearching = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Delay map initialization to reduce startup load
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Dispose and recreate map controller when app is resumed
    // This helps prevent OpenGL issues on emulators
    if (state == AppLifecycleState.resumed) {
      if (_mapController != null) {
        _mapController!.dispose();
        _mapController = null;
        if (mounted) setState(() {});
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounceTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  // Debounced marker update to avoid too many redraws
  void _updateMarkerDebounced(double lat, double lng) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      // Only update if position changed significantly
      if (_lastPosition == null ||
          (_lastPosition!.latitude - lat).abs() > 0.00001 ||
          (_lastPosition!.longitude - lng).abs() > 0.00001) {
        _lastPosition = LatLng(lat, lng);

        setState(() {
          _markers = {
            Marker(
              markerId: const MarkerId('current_location'),
              position: _lastPosition!,
              infoWindow: const InfoWindow(title: 'Mi Ubicación'),
            ),
          };
        });
      }
    });
  }
  double _currentZoom = 15;

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geolocalización'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<LocationProvider>(
        builder: (context, provider, child) {
          final loc = provider.location;

          if (loc != null && _mapReady) {
            _updateMarkerDebounced(loc.latitude, loc.longitude);
          }

          return Stack(
            children: [
              _buildMapWidget(provider),
              // Campo de búsqueda arriba
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar dirección...',
                      suffixIcon: _isSearching
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                _searchAndGo(_searchController.text);
                              },
                            ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: _searchAndGo,
                  ),
                ),
              ),
              if (loc != null)
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: info_widget.LocationInfoWidget(),
                ),
              // Botones de zoom personalizados
              Positioned(
                bottom: 100,
                right: 16,
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'zoom_in',
                      mini: true,
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.add, color: Colors.blue),
                      onPressed: () async {
                        if (_mapController != null) {
                          _currentZoom += 1;
                          await _mapController!.animateCamera(
                            CameraUpdate.zoomTo(_currentZoom),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: 'zoom_out',
                      mini: true,
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.remove, color: Colors.blue),
                      onPressed: () async {
                        if (_mapController != null) {
                          _currentZoom -= 1;
                          await _mapController!.animateCamera(
                            CameraUpdate.zoomTo(_currentZoom),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final loc = Provider.of<LocationProvider>(context, listen: false).location;
          if (loc != null && _mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLng(LatLng(loc.latitude, loc.longitude)),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildMapWidget(LocationProvider provider) {
    final loc = provider.location;

    if (loc == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(loc.latitude, loc.longitude),
        zoom: _currentZoom,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false, // Oculta los controles nativos, usamos los personalizados
      compassEnabled: true,
      mapToolbarEnabled: true,
      tiltGesturesEnabled: true,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      liteModeEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        setState(() {
          _mapReady = true;
        });
      },
      onCameraMove: (position) {
        _currentZoom = position.zoom;
      },
    );
  }
}
