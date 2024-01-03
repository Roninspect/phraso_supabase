// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Activities {
  String? activitiesId;
  final String pdId;
  final String place;
  final DateTime startTime;
  final DateTime endTime;
  final String tripId;
  Activities({
    this.activitiesId,
    required this.pdId,
    required this.place,
    required this.startTime,
    required this.endTime,
    required this.tripId,
  });

  Activities copyWith({
    String? activitiesId,
    String? pdId,
    String? place,
    DateTime? startTime,
    DateTime? endTime,
    String? tripId,
  }) {
    return Activities(
        activitiesId: activitiesId ?? this.activitiesId,
        pdId: pdId ?? this.pdId,
        place: place ?? this.place,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        tripId: tripId ?? this.tripId);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pd_id': pdId,
      'place': place,
      'start_time': startTime.toString(),
      'end_time': endTime.toString(),
      'trip_id': tripId
    };
  }

  factory Activities.fromMap(Map<String, dynamic> map) {
    return Activities(
        activitiesId: map['activities_id'] as String,
        pdId: map['pd_id'] as String,
        place: map['place'] as String,
        startTime: DateTime.parse(map['start_time'] as String),
        endTime: DateTime.parse(map['end_time'] as String),
        tripId: map['trip_id'] as String);
  }

  String toJson() => json.encode(toMap());

  factory Activities.fromJson(String source) =>
      Activities.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Activities(activitiesId: $activitiesId, pdId: $pdId, place: $place, startTime: $startTime, endTime: $endTime, tripId: $tripId)';
  }

  @override
  bool operator ==(covariant Activities other) {
    if (identical(this, other)) return true;

    return other.activitiesId == activitiesId &&
        other.pdId == pdId &&
        other.place == place &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.tripId == tripId;
  }

  @override
  int get hashCode {
    return activitiesId.hashCode ^
        pdId.hashCode ^
        place.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        tripId.hashCode;
  }
}
