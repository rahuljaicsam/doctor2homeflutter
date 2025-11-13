import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Available', 'Rating', 'Distance', 'Price'];

  // Mock data for doctors
  final List<Map<String, dynamic>> _doctors = [
    {
      'id': '1',
      'name': 'Dr. Sarah Johnson',
      'specialty': 'General Physician',
      'rating': 4.8,
      'reviews': 156,
      'distance': 2.3,
      'fee': 500,
      'imageUrl': 'https://via.placeholder.com/100',
      'isAvailable': true,
      'experience': '8 years',
      'qualification': 'MBBS, MD',
      'languages': ['English', 'Hindi'],
      'description': 'Experienced general physician with expertise in family medicine and preventive care.',
    },
    {
      'id': '2',
      'name': 'Dr. Michael Chen',
      'specialty': 'Cardiologist',
      'rating': 4.9,
      'reviews': 203,
      'distance': 1.8,
      'fee': 800,
      'imageUrl': 'https://via.placeholder.com/100',
      'isAvailable': true,
      'experience': '12 years',
      'qualification': 'MBBS, DM Cardiology',
      'languages': ['English', 'Chinese'],
      'description': 'Senior cardiologist specializing in heart diseases and cardiac care.',
    },
    {
      'id': '3',
      'name': 'Dr. Emily Davis',
      'specialty': 'Pediatrician',
      'rating': 4.7,
      'reviews': 89,
      'distance': 3.1,
      'fee': 600,
      'imageUrl': 'https://via.placeholder.com/100',
      'isAvailable': false,
      'experience': '6 years',
      'qualification': 'MBBS, DCH',
      'languages': ['English', 'Spanish'],
      'description': 'Child specialist providing comprehensive pediatric care.',
    },
    {
      'id': '4',
      'name': 'Dr. Rajesh Kumar',
      'specialty': 'Dermatologist',
      'rating': 4.6,
      'reviews': 124,
      'distance': 2.7,
      'fee': 700,
      'imageUrl': 'https://via.placeholder.com/100',
      'isAvailable': true,
      'experience': '10 years',
      'qualification': 'MBBS, MD Dermatology',
      'languages': ['English', 'Hindi', 'Punjabi'],
      'description': 'Skin specialist with expertise in cosmetic and medical dermatology.',
    },
  ];

  List<Map<String, dynamic>> get _filteredDoctors {
    switch (_selectedFilter) {
      case 'Available':
        return _doctors.where((doctor) => doctor['isAvailable'] == true).toList();
      case 'Rating':
        return List.from(_doctors)..sort((a, b) => b['rating'].compareTo(a['rating']));
      case 'Distance':
        return List.from(_doctors)..sort((a, b) => a['distance'].compareTo(b['distance']));
      case 'Price':
        return List.from(_doctors)..sort((a, b) => a['fee'].compareTo(b['fee']));
      default:
        return _doctors;
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final specialty = arguments?['specialty'] ?? 'All Doctors';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(specialty),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.blue.shade100,
                    checkmarkColor: Colors.blue.shade600,
                  ),
                );
              },
            ),
          ),

          // Doctor list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = _filteredDoctors[index];
                return _buildDoctorCard(doctor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Doctor header
            Row(
              children: [
                // Doctor image
                CircleAvatar(
                  radius: 35,
                  backgroundImage: CachedNetworkImageProvider(doctor['imageUrl']),
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
                            doctor['name'],
                            style: const TextStyle(
                              fontSize: 18,
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
                      const SizedBox(height: 4),
                      Text(
                        doctor['specialty'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Rating and reviews
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: doctor['rating'],
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 16,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                            ignoreGestures: true,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${doctor['rating']} (${doctor['reviews']} reviews)',
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
                            '${doctor['distance']} km',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Experience and qualification
                      Row(
                        children: [
                          Icon(
                            Icons.work,
                            size: 14,
                            color: Colors.grey.shade400,
                          ),
                          Text(
                            ' ${doctor['experience']} • ${doctor['qualification']}',
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
              ],
            ),

            const SizedBox(height: 16),

            // Doctor description
            Text(
              doctor['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 16),

            // Languages and fee
            Row(
              children: [
                // Languages
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Languages: ${doctor['languages'].join(', ')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Fee and book button
                Row(
                  children: [
                    Text(
                      '₹${doctor['fee']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: doctor['isAvailable'] ? () => _bookAppointment(doctor) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: doctor['isAvailable']
                            ? Colors.blue.shade600
                            : Colors.grey.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        doctor['isAvailable'] ? 'Book Now' : 'Unavailable',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort & Filter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('All Doctors'),
                leading: Radio<String>(
                  value: 'All',
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Available Only'),
                leading: Radio<String>(
                  value: 'Available',
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Highest Rated'),
                leading: Radio<String>(
                  value: 'Rating',
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Nearest'),
                leading: Radio<String>(
                  value: 'Distance',
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Lowest Fee'),
                leading: Radio<String>(
                  value: 'Price',
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _bookAppointment(Map<String, dynamic> doctor) {
    Navigator.of(context).pushNamed('/booking', arguments: doctor);
  }
}
