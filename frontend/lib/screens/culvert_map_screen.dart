import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/culvert_data.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/culvert_provider.dart';
import 'package:frontend/widgets/pipe/pipe_form_card.dart';

class CulvertMapScreen extends StatefulWidget {
  const CulvertMapScreen({super.key});

  @override
  State<CulvertMapScreen> createState() => _CulvertMapScreenState();
}

class _CulvertMapScreenState extends State<CulvertMapScreen> {
  final MapController _mapController = MapController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final culvertProvider = Provider.of<CulvertProvider>(context, listen: false);
      if (authProvider.user != null) {
        await culvertProvider.fetchCulverts(authProvider.user!);
      }
      setState(() => _isLoading = false);
    });
  }

  void _onMapTap(LatLng tappedPoint, User user) {
  final culvertProvider = Provider.of<CulvertProvider>(context, listen: false);

  culvertProvider.createNewCulvertWithSave(
    context,
    user,
    latitude: tappedPoint.latitude,
    longitude: tappedPoint.longitude,
  );
}


  void _onMarkerTap(CulvertData culvert, User user) {
    showDialog(
      context: context,
      builder: (_) => PipeFormCard(
        user: user,
        initialData: culvert,
        isEditing: true,
        onSave: (updatedCulvert) async {
          await Provider.of<CulvertProvider>(context, listen: false).fetchCulverts(user);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final culverts = context.watch<CulvertProvider>().culverts;
    final user = context.watch<AuthProvider>().user;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Пользователь не найден')));
    }

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта труб'),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(51.1605, 71.4704),
          initialZoom: 11.0,
          onMapReady: () => _mapController.move(LatLng(51.1605, 71.4704), 11.0),
          onTap: (_, tappedPoint) => _onMapTap(tappedPoint, user),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.trubochisty',
          ),
          MarkerLayer(
            markers: culverts.where((c) => c.coordinates != null).map((culvert) {
              final coords = culvert.coordinates!.split(',');
              final lat = double.tryParse(coords[0]) ?? 0.0;
              final lng = double.tryParse(coords[1]) ?? 0.0;

              return Marker(
                point: LatLng(lat, lng),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => _onMarkerTap(culvert, user),
                  child: const Icon(Icons.location_on, color: Colors.red, size: 32),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:provider/provider.dart';
// import 'package:geolocator/geolocator.dart';
// import '../models/culvert_data.dart';
// import '../providers/culvert_provider.dart';
// import '../widgets/pipe/pipe_form_card.dart';
// import '../widgets/pipe/identification_section.dart';

// class CulvertMapScreen extends StatefulWidget {
//   const CulvertMapScreen({super.key});

//   @override
//   State<CulvertMapScreen> createState() => _CulvertMapScreenState();
// }

// class _CulvertMapScreenState extends State<CulvertMapScreen> {
//   late final MapController _mapController;
//   CulvertData? _selectedCulvert;
//   bool _isNew = false;

//   @override
//   void initState() {
//     super.initState();
//     _mapController = MapController();
//   }

//   void _centerMapOnCulvert(CulvertData culvert) {
//     final latlng = LatLng(culvert.latitude!, culvert.longitude!);
//     _mapController.move(latlng, 16);
//   }

//   Future<void> _goToMyLocation() async {
//     final position = await Geolocator.getCurrentPosition();
//     _mapController.move(LatLng(position.latitude, position.longitude), 15);
//   }

//   void _startNewCulvertAt(LatLng latlng) {
//     final newData = CulvertData(
//       coordinates: '${latlng.latitude},${latlng.longitude}',
//     );
//     setState(() {
//       _selectedCulvert = newData;
//       _isNew = true;
//     });
//   }

//   void _selectExistingCulvert(CulvertData culvert) {
//     setState(() {
//       _selectedCulvert = culvert;
//       _isNew = false;
//     });
//     _centerMapOnCulvert(culvert);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final culverts = context.watch<CulvertProvider>().culverts;

//     final markers = culverts
//         .where((c) => c.latitude != null && c.longitude != null)
//         .map((culvert) {
//       final latlng = LatLng(culvert.latitude!, culvert.longitude!);
//       return Marker(
//         point: latlng,
//         width: 40,
//         height: 40,
//         child: GestureDetector(
//           onTap: () => _selectExistingCulvert(culvert),
//           child: const Icon(Icons.location_on, color: Colors.red, size: 36),
//         ),
//       );
//     }).toList();

//     return Scaffold(
//       body: Stack(
//         children: [
//           FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(
//               initialCenter: culverts.isNotEmpty
//                   ? LatLng(
//                       culverts.first.latitude!, culverts.first.longitude!)
//                   : const LatLng(55.7558, 37.6173),
//               initialZoom: 10,
//               interactionOptions:
//                   const InteractionOptions(flags: InteractiveFlag.all),
//               onTap: (tapPosition, latlng) {
//                 _startNewCulvertAt(latlng);
//               },
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate:
//                     'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
//                 subdomains: ['a', 'b', 'c', 'd'],
//                 tileProvider: NetworkTileProvider(),
//               ),
//               MarkerLayer(markers: markers),
//             ],
//           ),
//           Positioned(
//             top: 40,
//             right: 20,
//             child: FloatingActionButton(
//               heroTag: 'location_btn',
//               onPressed: _goToMyLocation,
//               child: const Icon(Icons.my_location),
//             ),
//           ),
//           if (_selectedCulvert != null)
//             Align(
//               alignment: Alignment.centerRight,
//               child: Container(
//                 width: 360,
//                 margin:
//                     const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                     ),
//                   ],
//                 ),
//                 child: Stack(
//                   children: [
//                     _isNew
//                         ? PipeFormCard(
//                             initialData: _selectedCulvert!,
//                             onDataChanged: (updated) {
//                               setState(() {
//                                 _selectedCulvert = updated;
//                               });
//                             },
//                           )
//                         : SingleChildScrollView(
//                             child: IdentificationSection(
//                               data: _selectedCulvert!,
//                               onDataChanged: (_) {},
//                             ),
//                           ),
//                     Positioned(
//                       top: 4,
//                       right: 4,
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _selectedCulvert = null;
//                           });
//                         },
//                         child: const CircleAvatar(
//                           radius: 14,
//                           backgroundColor: Colors.black26,
//                           child:
//                               Icon(Icons.close, size: 18, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//         ],
//       ),
//     );
//   }
// }
