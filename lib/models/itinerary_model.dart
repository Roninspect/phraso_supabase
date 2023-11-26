class ItineraryModel {
  String tripId;
  String tripName;
  String background;
  num startDate;
  num endTime;
  List<String> members;
  String creatorId;
  String place;

  ItineraryModel(
      {required this.tripId,
      required this.tripName,
      required this.background,
      required this.startDate,
      required this.endTime,
      required this.members,
      required this.creatorId,
      required this.place});

  ItineraryModel copyWith({
    String? tripId,
    String? tripName,
    String? background,
    num? startDate,
    num? endTime,
    List<String>? members,
    String? creatorId,
    String? place,
  }) {
    return ItineraryModel(
      tripId: tripId ?? this.tripId,
      tripName: tripName ?? this.tripName,
      place: place ?? this.place,
      background: background ?? this.background,
      startDate: startDate ?? this.startDate,
      endTime: endTime ?? this.endTime,
      members: members ?? this.members,
      creatorId: creatorId ?? this.creatorId,
    );
  }

  factory ItineraryModel.fromMap(Map<String, dynamic> map) {
    return ItineraryModel(
      tripId: map['tripId'],
      tripName: map['tripName'],
      place: map['place'],
      background: map['background'],
      startDate: map['startDate'],
      endTime: map['endTime'],
      members: List<String>.from(
          (map['members'] as List<dynamic>).map((e) => e as String).toList()),
      creatorId: map['creatorId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'tripName': tripName,
      'background': background,
      'startDate': startDate,
      'endTime': endTime,
      'members': members,
      'place': place,
      'creatorId': creatorId
    };
  }
}
