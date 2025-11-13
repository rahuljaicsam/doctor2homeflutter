class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String userType; // 'patient' or 'doctor'
  final String? profileImageUrl;
  final Map<String, dynamic>? address;
  final bool isProfileComplete;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.profileImageUrl,
    this.address,
    this.isProfileComplete = false,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      userType: map['userType'] ?? 'patient',
      profileImageUrl: map['profileImageUrl'],
      address: map['address'],
      isProfileComplete: map['isProfileComplete'] ?? false,
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
      'userType': userType,
      'profileImageUrl': profileImageUrl,
      'address': address,
      'isProfileComplete': isProfileComplete,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? userType,
    String? profileImageUrl,
    Map<String, dynamic>? address,
    bool? isProfileComplete,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      address: address ?? this.address,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
