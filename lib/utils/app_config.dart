class AppConfig {
  // App Info
  static const String appName = 'Doctor2Home';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Healthcare at your doorstep';

  // API Keys (replace with your actual keys)
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  static const String razorpayKey = 'YOUR_RAZORPAY_KEY';
  static const String stripePublishableKey = 'YOUR_STRIPE_PUBLISHABLE_KEY';

  // Firebase Collection Names
  static const String usersCollection = 'users';
  static const String doctorsCollection = 'doctors';
  static const String bookingsCollection = 'bookings';
  static const String reviewsCollection = 'reviews';
  static const String addressesCollection = 'addresses';

  // Booking Status
  static const List<String> bookingStatuses = [
    'pending',
    'confirmed',
    'in_progress',
    'completed',
    'cancelled',
  ];

  // Payment Methods
  static const List<String> paymentMethods = [
    'Online Payment',
    'Cash on Visit',
    'Insurance',
  ];

  // Doctor Specialties
  static const List<String> doctorSpecialties = [
    'General Physician',
    'Cardiologist',
    'Dermatologist',
    'Pediatrician',
    'Psychiatrist',
    'Gynecologist',
    'Orthopedic',
    'ENT Specialist',
    'Ophthalmologist',
    'Neurologist',
    'Urologist',
    'Endocrinologist',
  ];

  // Time Slots
  static const List<String> timeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
  ];

  // Week Days
  static const List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // Languages
  static const List<String> languages = [
    'English',
    'Hindi',
    'Bengali',
    'Telugu',
    'Tamil',
    'Gujarati',
    'Punjabi',
    'Marathi',
    'Kannada',
    'Malayalam',
  ];

  // Default Location
  static const double defaultLatitude = 28.6139;
  static const double defaultLongitude = 77.2090; // Delhi coordinates

  // Pagination
  static const int defaultPageSize = 20;

  // Image URLs
  static const String defaultDoctorImage = 'https://via.placeholder.com/150';
  static const String defaultUserImage = 'https://via.placeholder.com/150';

  // Colors
  static const int primaryColor = 0xFF2196F3;
  static const int secondaryColor = 0xFF4CAF50;
  static const int accentColor = 0xFFFF9800;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPhoneLength = 15;
  static const int minNameLength = 2;
}
