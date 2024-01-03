// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:phraso/models/itinerary_model.dart';

class ItineraryMember {
  String? id;
  DateTime? joinedAt;
  final String itineraryId;
  final String userId;
  final bool isAdmin;
  ItineraryModel? itineraries;
  ItineraryMember({
    this.id,
    this.joinedAt,
    required this.itineraryId,
    required this.userId,
    required this.isAdmin,
    this.itineraries,
  });

  ItineraryMember copyWith({
    String? id,
    DateTime? joinedAt,
    String? itineraryId,
    String? userId,
    bool? isAdmin,
    ItineraryModel? itineraries,
  }) {
    return ItineraryMember(
      id: id ?? this.id,
      joinedAt: joinedAt ?? this.joinedAt,
      itineraryId: itineraryId ?? this.itineraryId,
      userId: userId ?? this.userId,
      isAdmin: isAdmin ?? this.isAdmin,
      itineraries: itineraries ?? this.itineraries,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itineraryId': itineraryId,
      'userId': userId,
      'is_Admin': isAdmin,
    };
  }

  factory ItineraryMember.fromMap(Map<String, dynamic> map) {
    return ItineraryMember(
      id: map['id'] as String,
      joinedAt: DateTime.parse(map['joined_at'] as String),
      itineraryId: map['itineraryId'] as String,
      userId: map['userId'] as String,
      isAdmin: map['is_Admin'] as bool,
      itineraries:
          ItineraryModel.fromMap(map['itineraries'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ItineraryMember.fromJson(String source) =>
      ItineraryMember.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItineraryMember(id: $id, joinedAt: $joinedAt, itineraryId: $itineraryId, userId: $userId, isAdmin: $isAdmin, itineraries: $itineraries)';
  }

  @override
  bool operator ==(covariant ItineraryMember other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.joinedAt == joinedAt &&
        other.itineraryId == itineraryId &&
        other.userId == userId &&
        other.isAdmin == isAdmin &&
        other.itineraries == itineraries;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        joinedAt.hashCode ^
        itineraryId.hashCode ^
        userId.hashCode ^
        isAdmin.hashCode ^
        itineraries.hashCode;
  }
}
