import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:doctor2home_app/providers/booking_provider.dart';
import 'package:doctor2home_app/providers/auth_provider.dart';

class ActiveBookingsScreen extends StatefulWidget {
  const ActiveBookingsScreen({super.key});

  @override
  State<ActiveBookingsScreen> createState() => _ActiveBookingsScreenState();
}

class _ActiveBookingsScreenState extends State<ActiveBookingsScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _loadActiveBookings();
  }

  Future<void> _loadActiveBookings() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
      await bookingProvider.loadBookings(authProvider.user!['uid']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Consumer2<BookingProvider, AuthProvider>(
        builder: (context, bookingProvider, authProvider, child) {
          if (bookingProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Get active bookings (confirmed and in progress)
          final activeBookings = bookingProvider.bookings.where((booking) =>
            booking['status'] == 'confirmed' || booking['status'] == 'in_progress'
          ).toList();

          if (activeBookings.isEmpty) {
            return _buildEmptyStateWithDemo();
          }

          return _buildActiveBookingsList(activeBookings);
        },
      ),
    );
  }

  Widget _buildEmptyStateWithDemo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today,
              size: 40,
              color: Colors.blue.shade600,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Active Bookings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your upcoming appointments will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                icon: const Icon(Icons.add),
                label: const Text('Book New'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {
                  _createDemoBooking();
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Demo'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.orange.shade600),
                  foregroundColor: Colors.orange.shade600,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveBookingsList(List<Map<String, dynamic>> activeBookings) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeBookings.length,
      itemBuilder: (context, index) {
        final booking = activeBookings[index];
        return _buildActiveBookingCard(booking);
      },
    );
  }

  Widget _buildActiveBookingCard(Map<String, dynamic> booking) {
    // Mock doctor location (in a real app, this would come from GPS tracking)
    final doctorLocation = const LatLng(40.7589, -73.9851); // Times Square
    final userLocation = const LatLng(40.7505, -73.9934); // Near High Line

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header with status and time
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: booking['status'] == 'confirmed'
                  ? Colors.green.shade50
                  : Colors.orange.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: booking['status'] == 'confirmed'
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking['status'] == 'confirmed' ? 'Confirmed' : 'In Progress',
                    style: TextStyle(
                      fontSize: 12,
                      color: booking['status'] == 'confirmed'
                          ? Colors.green.shade600
                          : Colors.orange.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('MMM dd, yyyy').format(booking['appointmentDate']),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Main booking info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Doctor info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        booking['doctorName'].toString().split(' ').map((word) => word[0]).join(''),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking['doctorName'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            booking['specialty'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber),
                              Text(
                                ' 4.8 • ${booking['appointmentTime']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${booking['fee']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Address
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey.shade600, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          booking['address'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Live tracking minimap
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: userLocation,
                      zoom: 14.0,
                      interactiveFlags: InteractiveFlag.none, // Disable interaction for minimap
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.doctor2home_app',
                      ),
                      MarkerLayer(
                        markers: [
                          // User location
                          Marker(
                            point: userLocation,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                              ),
                              child: const Icon(
                                Icons.home,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          // Doctor location
                          Marker(
                            point: doctorLocation,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green.shade600,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                              ),
                              child: const Icon(
                                Icons.local_hospital,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Route line (simplified)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: [userLocation, doctorLocation],
                            color: Colors.blue.shade600,
                            strokeWidth: 4.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ETA and actions
                Row(
                  children: [
                    // ETA
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.blue.shade600, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'ETA: 15 mins',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Call button
                    ElevatedButton.icon(
                      onPressed: () {
                        _showCallDialog(booking);
                      },
                      icon: const Icon(Icons.call, size: 18),
                      label: const Text('Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Cancel button
                    OutlinedButton.icon(
                      onPressed: () {
                        _showCancelDialog(booking);
                      },
                      icon: const Icon(Icons.cancel, size: 18),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade600),
                        foregroundColor: Colors.red.shade600,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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

  void _showCallDialog(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Doctor'),
        content: Text('Call ${booking['doctorName']} at your appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling ${booking['doctorName']}...'),
                  backgroundColor: Colors.green.shade600,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: Text('Are you sure you want to cancel your appointment with ${booking['doctorName']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No, Keep'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

              bool success = await bookingProvider.updateBookingStatus(
                booking['id'],
                'cancelled',
              );

              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Appointment cancelled successfully'),
                    backgroundColor: Colors.orange,
                  ),
                );
                setState(() {}); // Refresh the list
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to cancel appointment'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _createDemoBooking() async {
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    // Create a demo active booking
    Map<String, dynamic> demoBooking = {
      'id': 'demo-active-${DateTime.now().millisecondsSinceEpoch}',
      'doctorId': 'demo-doc-1',
      'doctorName': 'Dr. Sarah Johnson',
      'specialty': 'General Physician',
      'patientId': 'mock-user-123',
      'appointmentDate': DateTime.now().add(const Duration(hours: 1)), // 1 hour from now
      'appointmentTime': '03:00 PM',
      'address': '123 Main St, New York, NY 10001',
      'fee': 1500,
      'paymentMethod': 'Online Payment',
      'status': 'confirmed',
      'createdAt': DateTime.now(),
    };

    // Add the demo booking
    bookingProvider.bookings.add(demoBooking);
    bookingProvider.notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo booking created! Check active bookings.'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
