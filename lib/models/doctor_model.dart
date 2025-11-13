class DoctorModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String specialty;
  final String qualification;
  final String experience;
  final double rating;
  final int totalReviews;
  final int fee;
  final String? profileImageUrl;
  final String? bio;
  final List<String> languages;
  final Map<String, dynamic>? clinicAddress;
  final bool isAvailable;
  final List<String> availableDays;
  final String startTime;
  final String endTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DoctorModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialty,
    required this.qualification,
    required this.experience,
    required this.rating,
    required this.totalReviews,
    required this.fee,
    this.profileImageUrl,
    this.bio,
    required this.languages,
    this.clinicAddress,
    required this.isAvailable,
    required this.availableDays,
    required this.startTime,
    required this.endTime,
    this.createdAt,
    this.updatedAt,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      specialty: map['specialty'] ?? '',
      qualification: map['qualification'] ?? '',
      experience: map['experience'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      totalReviews: map['totalReviews'] ?? 0,
      fee: map['fee'] ?? 0,
      profileImageUrl: map['profileImageUrl'],
      bio: map['bio'],
      languages: List<String>.from(map['languages'] ?? []),
      clinicAddress: map['clinicAddress'],
      isAvailable: map['isAvailable'] ?? false,
      availableDays: List<String>.from(map['availableDays'] ?? []),
      startTime: map['startTime'] ?? '09:00',
      endTime: map['endTime'] ?? '18:00',
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'specialty': specialty,
      'qualification': qualification,
      'experience': experience,
      'rating': rating,
      'totalReviews': totalReviews,
      'fee': fee,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'languages': languages,
      'clinicAddress': clinicAddress,
      'isAvailable': isAvailable,
      'availableDays': availableDays,
      'startTime': startTime,
      'endTime': endTime,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  String get displayFee => '₹$fee';
  String get displayRating => rating.toStringAsFixed(1);
  String get displayExperience => '$experience experience';
}
