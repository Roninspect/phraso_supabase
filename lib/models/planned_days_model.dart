// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PlannedDaysModel {
  String? day_id;
  final DateTime day_date;
  final String itinerary_id;
  PlannedDaysModel({
    this.day_id,
    required this.day_date,
    required this.itinerary_id,
  });

  PlannedDaysModel copyWith({
    String? day_id,
    DateTime? day_date,
    String? itinerary_id,
  }) {
    return PlannedDaysModel(
      day_id: day_id ?? this.day_id,
      day_date: day_date ?? this.day_date,
      itinerary_id: itinerary_id ?? this.itinerary_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'day_date': day_date.toString(),
      'itinerary_id': itinerary_id,
    };
  }

  factory PlannedDaysModel.fromMap(Map<String, dynamic> map) {
    return PlannedDaysModel(
      day_id: map['day_id'] as String,
      day_date: DateTime.parse(map['day_date'] as String),
      itinerary_id: map['itinerary_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlannedDaysModel.fromJson(String source) =>
      PlannedDaysModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PlannedDaysModel(day_id: $day_id, day_date: $day_date, itinerary_id: $itinerary_id)';

  @override
  bool operator ==(covariant PlannedDaysModel other) {
    if (identical(this, other)) return true;

    return other.day_id == day_id &&
        other.day_date == day_date &&
        other.itinerary_id == itinerary_id;
  }

  @override
  int get hashCode =>
      day_id.hashCode ^ day_date.hashCode ^ itinerary_id.hashCode;
}
