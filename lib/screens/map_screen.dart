import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;

  // Mock doctor locations (realistic coordinates around New York area)
  final List<Map<String, dynamic>> _doctorLocations = [
    {
      'id': '1',
      'name': 'Dr. Sarah Johnson',
      'specialty': 'General Physician',
      'location': const LatLng(40.7589, -73.9851), // Times Square area
      'fee': 500,
      'rating': 4.8,
      'isAvailable': true,
    },
    {
      'id': '2',
      'name': 'Dr. Michael Chen',
      'specialty': 'Cardiologist',
      'location': const LatLng(40.7505, -73.9934), // Near High Line
      'fee': 800,
      'rating': 4.9,
      'isAvailable': true,
    },
    {
      'id': '3',
      'name': 'Dr. Emily Davis',
      'specialty': 'Pediatrician',
      'location': const LatLng(40.7831, -73.9712), // Central Park area
      'fee': 600,
      'rating': 4.7,
      'isAvailable': true,
    },
    {
      'id': '4',
      'name': 'Dr. James Wilson',
      'specialty': 'Dermatologist',
      'location': const LatLng(40.7282, -73.7949), // Queens area
      'fee': 700,
      'rating': 4.6,
      'isAvailable': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // For demo, use New York City as default location
      setState(() {
        _currentLocation = const LatLng(40.7128, -74.0060);
      });
    } catch (e) {
      // Fallback to default location
      setState(() {
        _currentLocation = const LatLng(40.7128, -74.0060);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _currentLocation!,
                zoom: 13.0,
                maxZoom: 18.0,
                minZoom: 10.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.doctor2home_app',
                  tileProvider: CancellableNetworkTileProvider(),
                ),
                MarkerLayer(
                  markers: [
                    // Current location marker
                    Marker(
                      point: _currentLocation!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    // Doctor location markers
                    ..._doctorLocations.map((doctor) => Marker(
                          point: doctor['location'],
                          child: GestureDetector(
                            onTap: () => _showDoctorDetails(doctor),
                            child: Container(
                              decoration: BoxDecoration(
                                color: doctor['isAvailable']
                                    ? Colors.green.shade600
                                    : Colors.red.shade600,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.local_hospital,
                                color: Colors.white,
                                size: doctor['isAvailable'] ? 24 : 20,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
                // Show distance circles
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _currentLocation!,
                      radius: 2000, // 2km radius
                      useRadiusInMeter: true,
                      color: Colors.blue.shade200.withOpacity(0.3),
                      borderColor: Colors.blue.shade600,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapController.move(_currentLocation!, 15.0);
        },
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.my_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showDoctorDetails(Map<String, dynamic> doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor info header
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: doctor['isAvailable']
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    child: Icon(
                      Icons.person,
                      color: doctor['isAvailable']
                          ? Colors.green.shade600
                          : Colors.red.shade600,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          doctor['specialty'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(
                              ' ${doctor['rating']} • ₹${doctor['fee']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: doctor['isAvailable']
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      doctor['isAvailable'] ? 'Available' : 'Busy',
                      style: TextStyle(
                        fontSize: 12,
                        color: doctor['isAvailable']
                            ? Colors.green.shade600
                            : Colors.red.shade600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: doctor['isAvailable']
                          ? () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed('/booking',
                                  arguments: {
                                    'id': doctor['id'],
                                    'name': doctor['name'],
                                    'specialty': doctor['specialty'],
                                    'fee': doctor['fee'],
                                  });
                            }
                          : null,
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Book Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: doctor['isAvailable']
                            ? Colors.blue.shade600
                            : Colors.grey.shade400,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/doctor-details',
                            arguments: doctor);
                      },
                      icon: const Icon(Icons.info_outline),
                      label: const Text('View Details'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.blue.shade600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Quick info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey.shade600, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Available for home visits',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.grey.shade600, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Response time: 15-30 mins',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
