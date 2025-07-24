import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Center of India
  final LatLng _indiaCenter = const LatLng(20.5937, 78.9629);
  final double _initialZoom = 5.0;
  
  // Sample disaster data - you'll replace this with real data later
  final List<Map<String, dynamic>> _disasterLocations = [
    {
      'name': 'Flood in Bihar',
      'type': 'Flood',
      'location': const LatLng(25.0961, 85.3131),
      'severity': 'High',
      'affected': '10,000 people',
    },
    {
      'name': 'Landslide in Uttarakhand',
      'type': 'Landslide',
      'location': const LatLng(30.0668, 79.0193),
      'severity': 'Medium',
      'affected': '500 people',
    },
    {
      'name': 'Cyclone Impact in Odisha',
      'type': 'Cyclone',
      'location': const LatLng(20.9517, 85.0985),
      'severity': 'High',
      'affected': '25,000 people',
    },
    {
      'name': 'Drought in Maharashtra Village',
      'type': 'Drought',
      'location': const LatLng(19.7515, 75.7139),
      'severity': 'Medium',
      'affected': '5,000 people',
    },
    {
      'name': 'Forest Fire in Himachal',
      'type': 'Fire',
      'location': const LatLng(31.1048, 77.1734),
      'severity': 'High',
      'affected': '1,000 people',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('India Disaster Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show info about the map
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Map Information'),
                  content: const Text('This map shows current disaster areas across India. Tap on any marker to see details about the disaster.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _indiaCenter,
          initialZoom: _initialZoom,
          maxZoom: 18.0,
          minZoom: 3.0,
        ),
        children: [
          // Base map layer
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.disaster_aid',
          ),
          
          // Disaster markers
          MarkerLayer(
            markers: _disasterLocations.map((disaster) {
              // Choose marker color based on disaster type
              Color markerColor;
              switch (disaster['type']) {
                case 'Flood':
                  markerColor = Colors.blue;
                  break;
                case 'Fire':
                  markerColor = Colors.red;
                  break;
                case 'Cyclone':
                  markerColor = Colors.purple;
                  break;
                case 'Landslide':
                  markerColor = Colors.brown;
                  break;
                case 'Drought':
                  markerColor = Colors.orange;
                  break;
                default:
                  markerColor = Colors.grey;
              }
              
              return Marker(
                point: disaster['location'],
                width: 40.0,
                height: 40.0,
                child: GestureDetector(
                  onTap: () {
                    // Show disaster details
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              disaster['name'],
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Chip(
                                  label: Text(disaster['type']),
                                  backgroundColor: markerColor.withAlpha(51),
                                  labelStyle: TextStyle(color: markerColor),
                                ),
                                const SizedBox(width: 8.0),
                                Chip(
                                  label: Text('Severity: ${disaster["severity"]}'),
                                  backgroundColor: Colors.grey.withAlpha(51),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text('Affected: ${disaster["affected"]}'),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.phone),
                                  label: const Text('Emergency Call'),
                                  onPressed: () {
                                    // TODO: Implement emergency call
                                  },
                                ),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.healing),
                                  label: const Text('Offer Help'),
                                  onPressed: () {
                                    // TODO: Implement offer help
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: markerColor.withAlpha(204), // 0.8 * 255 = 204
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Icon(
                        _getIconForDisasterType(disaster['type']),
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'locate',
            onPressed: () {
              // TODO: Implement user location
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 16.0),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () {
              // TODO: Implement report disaster
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
  
  IconData _getIconForDisasterType(String type) {
    switch (type) {
      case 'Flood':
        return Icons.water;
      case 'Fire':
        return Icons.local_fire_department;
      case 'Cyclone':
        return Icons.cyclone;
      case 'Landslide':
        return Icons.landscape;
      case 'Drought':
        return Icons.wb_sunny;
      default:
        return Icons.warning;
    }
  }
}