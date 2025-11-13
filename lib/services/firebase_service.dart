import 'dart:async';

class MockQuerySnapshot {
  final List<MockDocumentSnapshot> docs;
  MockQuerySnapshot(this.docs);
}

class MockDocumentSnapshot {
  final String id;
  final Map<String, dynamic> _data;
  MockDocumentSnapshot(this.id, this._data);

  Map<String, dynamic> data() => _data;
  bool exists = true;
}

class FirebaseService {
  // Mock data for doctors
  final List<Map<String, dynamic>> _mockDoctors = [
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
      'isAvailable': true,
      'experience': '6 years',
      'qualification': 'MBBS, DCH',
      'languages': ['English', 'Spanish'],
      'description': 'Pediatric specialist providing comprehensive child healthcare.',
    },
    {
      'id': '4',
      'name': 'Dr. James Wilson',
      'specialty': 'Dermatologist',
      'rating': 4.6,
      'reviews': 124,
      'distance': 1.5,
      'fee': 700,
      'imageUrl': 'https://via.placeholder.com/100',
      'isAvailable': false,
      'experience': '10 years',
      'qualification': 'MBBS, MD Dermatology',
      'languages': ['English'],
      'description': 'Expert in skin care and dermatological treatments.',
    },
  ];

  // Generic method to get collection data (mock)
  Stream<MockQuerySnapshot> getCollectionStream(String collection) {
    final controller = StreamController<MockQuerySnapshot>();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (collection == 'doctors') {
        final docs = _mockDoctors.map((doc) => MockDocumentSnapshot(doc['id'], doc)).toList();
        controller.add(MockQuerySnapshot(docs));
      } else {
        controller.add(MockQuerySnapshot([]));
      }
      controller.close();
    });

    return controller.stream;
  }

  // Generic method to get document by ID (mock)
  Future<MockDocumentSnapshot> getDocument(String collection, String docId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (collection == 'doctors') {
      final doctor = _mockDoctors.firstWhere((doc) => doc['id'] == docId);
      return MockDocumentSnapshot(doctor['id'], doctor);
    }

    return MockDocumentSnapshot('', {});
  }

  // Generic method to add document (mock)
  Future<String> addDocument(String collection, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'mock-doc-${DateTime.now().millisecondsSinceEpoch}';
  }

  // Generic method to update document (mock)
  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Generic method to delete document (mock)
  Future<void> deleteDocument(String collection, String docId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Get doctors by specialty (mock)
  Stream<MockQuerySnapshot> getDoctorsBySpecialty(String specialty) {
    final controller = StreamController<MockQuerySnapshot>();

    Future.delayed(const Duration(milliseconds: 500), () {
      final filteredDoctors = _mockDoctors.where((doc) => doc['specialty'] == specialty).toList();
      final docs = filteredDoctors.map((doc) => MockDocumentSnapshot(doc['id'], doc)).toList();
      controller.add(MockQuerySnapshot(docs));
      controller.close();
    });

    return controller.stream;
  }

  // Search doctors by name or specialty (mock)
  Stream<MockQuerySnapshot> searchDoctors(String query) {
    final controller = StreamController<MockQuerySnapshot>();

    Future.delayed(const Duration(milliseconds: 500), () {
      final filteredDoctors = _mockDoctors.where((doc) =>
        doc['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
        doc['specialty'].toString().toLowerCase().contains(query.toLowerCase())
      ).toList();
      final docs = filteredDoctors.map((doc) => MockDocumentSnapshot(doc['id'], doc)).toList();
      controller.add(MockQuerySnapshot(docs));
      controller.close();
    });

    return controller.stream;
  }

  // Get user bookings (mock)
  Stream<MockQuerySnapshot> getUserBookings(String userId) {
    final controller = StreamController<MockQuerySnapshot>();

    Future.delayed(const Duration(milliseconds: 500), () {
      // Return empty list for mock implementation
      controller.add(MockQuerySnapshot([]));
      controller.close();
    });

    return controller.stream;
  }

  // Get doctor bookings (mock)
  Stream<MockQuerySnapshot> getDoctorBookings(String doctorId) {
    final controller = StreamController<MockQuerySnapshot>();

    Future.delayed(const Duration(milliseconds: 500), () {
      controller.add(MockQuerySnapshot([]));
      controller.close();
    });

    return controller.stream;
  }

  // Update booking status (mock)
  Future<void> updateBookingStatus(String bookingId, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Add review (mock)
  Future<void> addReview(String bookingId, double rating, String review) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Get nearby doctors (mock implementation)
  Stream<MockQuerySnapshot> getNearbyDoctors(double latitude, double longitude) {
    final controller = StreamController<MockQuerySnapshot>();

    Future.delayed(const Duration(milliseconds: 500), () {
      final docs = _mockDoctors.map((doc) => MockDocumentSnapshot(doc['id'], doc)).toList();
      controller.add(MockQuerySnapshot(docs));
      controller.close();
    });

    return controller.stream;
  }
}
