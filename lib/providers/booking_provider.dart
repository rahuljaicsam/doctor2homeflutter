import 'package:flutter/material.dart';

class BookingProvider with ChangeNotifier {
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get bookings => _bookings;
  bool get isLoading => _isLoading;

  // Mock booking data for demonstration
  List<Map<String, dynamic>> get mockBookings => [
    {
      'id': 'booking-1',
      'doctorId': 'doc-1',
      'doctorName': 'Dr. Sarah Johnson',
      'specialty': 'General Physician',
      'patientId': 'mock-user-123',
      'appointmentDate': DateTime.now().add(const Duration(days: 1)),
      'appointmentTime': '10:00 AM',
      'address': '123 Main St, City, State',
      'fee': 1500,
      'paymentMethod': 'Online Payment',
      'status': 'confirmed',
      'createdAt': DateTime.now(),
    },
    {
      'id': 'booking-2',
      'doctorId': 'doc-2',
      'doctorName': 'Dr. Michael Chen',
      'specialty': 'Cardiologist',
      'patientId': 'mock-user-123',
      'appointmentDate': DateTime.now().add(const Duration(days: 3)),
      'appointmentTime': '02:00 PM',
      'address': '456 Oak Ave, City, State',
      'fee': 2500,
      'paymentMethod': 'Cash on Visit',
      'status': 'pending',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  // Mock active booking for demonstration
  List<Map<String, dynamic>> get mockActiveBookings => [
    {
      'id': 'active-booking-1',
      'doctorId': 'doc-1',
      'doctorName': 'Dr. Sarah Johnson',
      'specialty': 'General Physician',
      'patientId': 'mock-user-123',
      'appointmentDate': DateTime.now().add(const Duration(hours: 2)), // 2 hours from now
      'appointmentTime': '02:00 PM',
      'address': '123 Main St, New York, NY 10001',
      'fee': 1500,
      'paymentMethod': 'Online Payment',
      'status': 'confirmed', // Active booking
      'createdAt': DateTime.now().subtract(const Duration(hours: 1)),
    },
  ];

  // Mock completed bookings for history demonstration
  List<Map<String, dynamic>> get mockCompletedBookings => [
    {
      'id': 'completed-booking-1',
      'doctorId': 'doc-1',
      'doctorName': 'Dr. Sarah Johnson',
      'specialty': 'General Physician',
      'patientId': 'mock-user-123',
      'appointmentDate': DateTime.now().subtract(const Duration(days: 7)), // 7 days ago
      'appointmentTime': '10:00 AM',
      'address': '123 Main St, New York, NY 10001',
      'fee': 1500,
      'paymentMethod': 'Online Payment',
      'status': 'completed',
      'createdAt': DateTime.now().subtract(const Duration(days: 8)),
      'consultationPhoto': 'https://via.placeholder.com/300x200?text=Consultation+Photo',
      'userRating': 5,
      'userReview': 'Excellent consultation! Dr. Johnson was very thorough and explained everything clearly. Highly recommend for any health concerns.',
      'userName': 'John Doe',
      'callDuration': 45, // minutes
      'consultationCompleted': true,
      'cancelledBy': null,
    },
    {
      'id': 'cancelled-booking-2',
      'doctorId': 'doc-2',
      'doctorName': 'Dr. Michael Chen',
      'specialty': 'Cardiologist',
      'patientId': 'mock-user-123',
      'appointmentDate': DateTime.now().subtract(const Duration(days: 14)), // 2 weeks ago
      'appointmentTime': '02:00 PM',
      'address': '456 Oak Ave, New York, NY 10002',
      'fee': 2500,
      'paymentMethod': 'Cash on Visit',
      'status': 'cancelled',
      'createdAt': DateTime.now().subtract(const Duration(days: 15)),
      'consultationPhoto': null,
      'userRating': null,
      'userReview': null,
      'userName': 'John Doe',
      'callDuration': null,
      'consultationCompleted': false,
      'cancelledBy': 'doctor', // Cancelled by doctor
    },
    {
      'id': 'completed-booking-3',
      'doctorId': 'doc-3',
      'doctorName': 'Dr. Emily Davis',
      'specialty': 'Pediatrician',
      'patientId': 'mock-user-123',
      'appointmentDate': DateTime.now().subtract(const Duration(days: 21)), // 3 weeks ago
      'appointmentTime': '09:00 AM',
      'address': '789 Pine St, New York, NY 10003',
      'fee': 1200,
      'paymentMethod': 'Insurance',
      'status': 'completed',
      'createdAt': DateTime.now().subtract(const Duration(days: 22)),
      'consultationPhoto': 'https://via.placeholder.com/300x200?text=Pediatric+Consultation',
      'userRating': 4,
      'userReview': 'Good experience overall. Doctor was patient and explained the treatment plan well.',
      'userName': 'John Doe',
      'callDuration': 30, // minutes
      'consultationCompleted': true,
      'cancelledBy': null,
    },
  ];

  BookingProvider() {
    // Initialize with all mock data
    _bookings = [
      ...mockBookings,
      ...mockActiveBookings,
      ...mockCompletedBookings,
    ];
  }

  Future<void> loadBookings(String userId) async {
    _isLoading = true;
    notifyListeners();

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    // Filter all mock bookings for the user (all types)
    final allMockData = [...mockBookings, ...mockActiveBookings, ...mockCompletedBookings];
    _bookings = allMockData.where((booking) => booking['patientId'] == userId).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createBooking(Map<String, dynamic> bookingData) async {
    // Simulate creation delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Add new booking to mock data
      Map<String, dynamic> newBooking = {
        'id': 'booking-${DateTime.now().millisecondsSinceEpoch}',
        ...bookingData,
        'status': 'confirmed',
        'createdAt': DateTime.now(),
      };

      _bookings.add(newBooking);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error creating booking: $e');
      return false;
    }
  }

  Future<bool> updateBookingStatus(String bookingId, String status) async {
    // Simulate update delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      int index = _bookings.indexWhere((booking) => booking['id'] == bookingId);
      if (index != -1) {
        _bookings[index]['status'] = status;
        _bookings[index]['updatedAt'] = DateTime.now();
        notifyListeners();
      }
      return true;
    } catch (e) {
      print('Error updating booking: $e');
      return false;
    }
  }
}
