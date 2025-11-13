import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:doctor2home_app/providers/auth_provider.dart';
import 'package:doctor2home_app/providers/location_provider.dart';
import 'package:doctor2home_app/utils/routes.dart';
import 'package:doctor2home_app/screens/map_screen.dart';
import 'package:doctor2home_app/screens/active_bookings_screen.dart';
import 'package:doctor2home_app/screens/booking_history_screen.dart';
import 'package:doctor2home_app/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of screens for each tab
  final List<Widget> _screens = [
    const _HomeTab(),
    const MapScreen(),
    const ActiveBookingsScreen(),
    const BookingHistoryScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    'Doctor2Home',
    'Find Doctors Near You',
    'Active Bookings',
    'Booking History',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Home Tab Widget
class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
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
    _loadLocation();
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

  Future<void> _loadLocation() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${authProvider.userData?['name']?.split(' ').first ?? 'User'}!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Find and book doctors near you',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blue.shade100,
                child: Icon(
                  Icons.person,
                  color: Colors.blue.shade600,
                  size: 30,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Quick actions
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              _buildQuickActionCard(
                icon: Icons.calendar_today,
                title: 'Book\nAppointment',
                color: Colors.blue.shade600,
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.booking);
                },
              ),
              const SizedBox(width: 12),
              _buildQuickActionCard(
                icon: Icons.map,
                title: 'Find\nDoctors',
                color: Colors.green.shade600,
                onTap: () {
                  setState(() {
                    // Switch to Map tab
                    final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                    homeState?._selectedIndex = 1;
                  });
                },
              ),
              const SizedBox(width: 12),
              _buildQuickActionCard(
                icon: Icons.emergency,
                title: 'Emergency\nCall',
                color: Colors.red.shade600,
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Location and mini map
          Text(
            'Doctors Near You',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _currentLocation == null
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
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // Map Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Available',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Busy',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'You',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Full Map Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  // Switch to Map tab
                  final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                  homeState?._selectedIndex = 1;
                });
              },
              icon: const Icon(Icons.map, color: Colors.white),
              label: const Text('View Full Map'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
          Text(
            'Available Doctors',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),

          // Doctor cards
          _buildDoctorCard(
            name: 'Dr. Sarah Johnson',
            specialty: 'General Physician',
            rating: 4.8,
            distance: '2.3 km',
            fee: '₹500',
            imageUrl: 'https://via.placeholder.com/60',
            isAvailable: true,
          ),

          const SizedBox(height: 12),

          _buildDoctorCard(
            name: 'Dr. Michael Chen',
            specialty: 'Cardiologist',
            rating: 4.9,
            distance: '1.8 km',
            fee: '₹800',
            imageUrl: 'https://via.placeholder.com/60',
            isAvailable: true,
          ),

          const SizedBox(height: 12),

          _buildDoctorCard(
            name: 'Dr. Emily Davis',
            specialty: 'Pediatrician',
            rating: 4.7,
            distance: '3.1 km',
            fee: '₹600',
            imageUrl: 'https://via.placeholder.com/60',
            isAvailable: false,
          ),

          const SizedBox(height: 32),

          // Emergency section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.emergency,
                  color: Colors.red.shade600,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Services',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '24/7 emergency doctor visits available',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Call Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorCard({
    required String name,
    required String specialty,
    required double rating,
    required String distance,
    required String fee,
    required String imageUrl,
    required bool isAvailable,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Doctor image
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(width: 16),

          // Doctor info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isAvailable ? Colors.green.shade100 : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isAvailable ? 'Available' : 'Busy',
                        style: TextStyle(
                          fontSize: 12,
                          color: isAvailable ? Colors.green.shade600 : Colors.red.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  specialty,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.yellow.shade600,
                    ),
                    Text(
                      ' $rating',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                    Text(
                      ' $distance',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      fee,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
