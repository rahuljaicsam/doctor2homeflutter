import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

class BookingModel {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String patientId;
  final String patientName;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String address;
  final int fee;
  final String paymentMethod;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final String? notes;
  final Map<String, dynamic>? patientSymptoms;
  final String? prescription;
  final double? doctorRating;
  final String? review;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  BookingModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.patientId,
    required this.patientName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.address,
    required this.fee,
    required this.paymentMethod,
    required this.status,
    required this.paymentStatus,
    this.notes,
    this.patientSymptoms,
    this.prescription,
    this.doctorRating,
    this.review,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map, String documentId) {
    return BookingModel(
      id: documentId,
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      doctorSpecialty: map['specialty'] ?? '',
      patientId: map['patientId'] ?? '',
      patientName: map['patientName'] ?? '',
      appointmentDate: (map['appointmentDate'] as Timestamp).toDate(),
      appointmentTime: map['appointmentTime'] ?? '',
      address: map['address'] ?? '',
      fee: map['fee'] ?? 0,
      paymentMethod: map['paymentMethod'] ?? '',
      status: BookingStatus.values[map['status'] ?? 0],
      paymentStatus: PaymentStatus.values[map['paymentStatus'] ?? 0],
      notes: map['notes'],
      patientSymptoms: map['patientSymptoms'],
      prescription: map['prescription'],
      doctorRating: map['doctorRating']?.toDouble(),
      review: map['review'],
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
      completedAt: map['completedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialty': doctorSpecialty,
      'patientId': patientId,
      'patientName': patientName,
      'appointmentDate': Timestamp.fromDate(appointmentDate),
      'appointmentTime': appointmentTime,
      'address': address,
      'fee': fee,
      'paymentMethod': paymentMethod,
      'status': status.index,
      'paymentStatus': paymentStatus.index,
      'notes': notes,
      'patientSymptoms': patientSymptoms,
      'prescription': prescription,
      'doctorRating': doctorRating,
      'review': review,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  String get displayFee => '₹$fee';
  String get statusText {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  String get paymentStatusText {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
      default:
        return 'Unknown';
    }
  }

  bool get isUpcoming => appointmentDate.isAfter(DateTime.now()) && status != BookingStatus.cancelled;
  bool get isCompleted => status == BookingStatus.completed;
  bool get isCancelled => status == BookingStatus.cancelled;
}
