// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:phraso/models/itinerary_member.dart';

class ItineraryModel {
  final String tripId;
  DateTime? created_at;
  final String tripName;
  String? background;
  final DateTime start_date;
  final DateTime end_date;
  final String creatorId;
  final String place;
  ItineraryModel({
    required this.tripId,
    this.created_at,
    required this.tripName,
    this.background,
    required this.start_date,
    required this.end_date,
    required this.creatorId,
    required this.place,
  });

  ItineraryModel copyWith({
    String? tripId,
    DateTime? created_at,
    String? tripName,
    String? background,
    DateTime? start_date,
    DateTime? end_date,
    String? creatorId,
    String? place,
  }) {
    return ItineraryModel(
      tripId: tripId ?? this.tripId,
      created_at: created_at ?? this.created_at,
      tripName: tripName ?? this.tripName,
      background: background ?? this.background,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      creatorId: creatorId ?? this.creatorId,
      place: place ?? this.place,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tripId': tripId,
      'tripName': tripName,
      'background': background,
      'start_date': start_date.toString(),
      'end_date': end_date.toString(),
      'creatorId': creatorId,
      'place': place,
    };
  }

  factory ItineraryModel.fromMap(Map<String, dynamic> map) {
    return ItineraryModel(
      tripId: map['tripId'] as String,
      created_at: DateTime.parse(map['created_at'] as String),
      tripName: map['tripName'] as String,
      background: map['background'] as String,
      start_date: DateTime.parse(map['start_date'] as String),
      end_date: DateTime.parse(map['end_date'] as String),
      creatorId: map['creatorId'] as String,
      place: map['place'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItineraryModel.fromJson(String source) =>
      ItineraryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItineraryModel(tripId: $tripId, created_at: $created_at, tripName: $tripName, background: $background, start_date: $start_date, end_date: $end_date, creatorId: $creatorId, place: $place)';
  }

  @override
  bool operator ==(covariant ItineraryModel other) {
    if (identical(this, other)) return true;

    return other.tripId == tripId &&
        other.created_at == created_at &&
        other.tripName == tripName &&
        other.background == background &&
        other.start_date == start_date &&
        other.end_date == end_date &&
        other.creatorId == creatorId &&
        other.place == place;
  }

  @override
  int get hashCode {
    return tripId.hashCode ^
        created_at.hashCode ^
        tripName.hashCode ^
        background.hashCode ^
        start_date.hashCode ^
        end_date.hashCode ^
        creatorId.hashCode ^
        place.hashCode;
  }
}
