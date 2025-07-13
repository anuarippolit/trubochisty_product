import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../models/culvert_data.dart';
import '../providers/culvert_provider.dart';
import '../widgets/pipe/pipe_form_card.dart';
import '../widgets/pipe/identification_section.dart';

class CulvertMapScreen extends StatefulWidget {
  const CulvertMapScreen({super.key});

  @override
  State<CulvertMapScreen> createState() => _CulvertMapScreenState();
}

class _CulvertMapScreenState extends State<CulvertMapScreen> {
  late final MapController _mapController;
  CulvertData? _selectedCulvert;
  bool _isNew = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _centerMapOnCulvert(CulvertData culvert) {
    final latlng = LatLng(culvert.latitude!, culvert.longitude!);
    _mapController.move(latlng, 16);
  }

  Future<void> _goToMyLocation() async {
    final position = await Geolocator.getCurrentPosition();
    _mapController.move(LatLng(position.latitude, position.longitude), 15);
  }

  void _startNewCulvertAt(LatLng latlng) {
    final newData = CulvertData(
      coordinates: '${latlng.latitude},${latlng.longitude}',
    );
    setState(() {
      _selectedCulvert = newData;
      _isNew = true;
    });
  }

  void _selectExistingCulvert(CulvertData culvert) {
    setState(() {
      _selectedCulvert = culvert;
      _isNew = false;
    });
    _centerMapOnCulvert(culvert);
  }

  @override
  Widget build(BuildContext context) {
    final culverts = context.watch<CulvertProvider>().culverts;

    final markers = culverts
        .where((c) => c.latitude != null && c.longitude != null)
        .map((culvert) {
      final latlng = LatLng(culvert.latitude!, culvert.longitude!);
      return Marker(
        point: latlng,
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => _selectExistingCulvert(culvert),
          child: const Icon(Icons.location_on, color: Colors.red, size: 36),
        ),
      );
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: culverts.isNotEmpty
                  ? LatLng(
                      culverts.first.latitude!, culverts.first.longitude!)
                  : const LatLng(55.7558, 37.6173),
              initialZoom: 10,
              interactionOptions:
                  const InteractionOptions(flags: InteractiveFlag.all),
              onTap: (tapPosition, latlng) {
                _startNewCulvertAt(latlng);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c', 'd'],
                tileProvider: NetworkTileProvider(),
              ),
              MarkerLayer(markers: markers),
            ],
          ),
          Positioned(
            top: 40,
            right: 20,
            child: FloatingActionButton(
              heroTag: 'location_btn',
              onPressed: _goToMyLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
          if (_selectedCulvert != null)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 360,
                margin:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    _isNew
                        ? PipeFormCard(
                            initialData: _selectedCulvert!,
                            onDataChanged: (updated) {
                              setState(() {
                                _selectedCulvert = updated;
                              });
                            },
                          )
                        : SingleChildScrollView(
                            child: IdentificationSection(
                              data: _selectedCulvert!,
                              onDataChanged: (_) {},
                            ),
                          ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCulvert = null;
                          });
                        },
                        child: const CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.black26,
                          child:
                              Icon(Icons.close, size: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
