class PlannedDaysModel {
  String planId;
  String plannedDaysId;
  String tripId;
  num dayNo;
  List<Activities> activities;
  PlannedDaysModel({
    required this.planId,
    required this.plannedDaysId,
    required this.tripId,
    required this.dayNo,
    required this.activities,
  });

  PlannedDaysModel copyWith({
    String? planId,
    String? plannedDaysId,
    String? tripId,
    num? dayNo,
    List<Activities>? activities,
  }) {
    return PlannedDaysModel(
      planId: planId ?? this.planId,
      plannedDaysId: plannedDaysId ?? this.plannedDaysId,
      tripId: tripId ?? this.tripId,
      dayNo: dayNo ?? this.dayNo,
      activities: activities ?? this.activities,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'planId': planId,
      'plannedDaysId': plannedDaysId,
      'tripId': tripId,
      'dayNo': dayNo,
      'activities': activities.map((x) => x.toMap()).toList(),
    };
  }

  factory PlannedDaysModel.fromMap(Map<String, dynamic> map) {
    print('Time value from Firestore: ${map['dayNo']}');
    return PlannedDaysModel(
        planId: map['planId'] as String,
        plannedDaysId: map['plannedDaysId'] as String,
        tripId: map['tripId'] as String,
        dayNo: map['dayNo'] as num,
        activities: List<Activities>.from(
          (map['activities'] as List<dynamic>).map<Activities>(
            (x) => Activities.fromMap(x as Map<String, dynamic>),
          ),
        ));
  }
}

class Activities {
  String place;
  num time;
  bool isPassed;
  Activities({
    required this.place,
    required this.time,
    required this.isPassed,
  });

  Activities copyWith({
    String? place,
    num? time,
    bool? isPassed,
  }) {
    return Activities(
      place: place ?? this.place,
      time: time ?? this.time,
      isPassed: isPassed ?? this.isPassed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'place': place,
      'time': time,
      'isPassed': isPassed,
    };
  }

  factory Activities.fromMap(Map<String, dynamic> map) {
    return Activities(
      place: map['place'] as String,
      time: map['time'] as num,
      isPassed: map['isPassed'] as bool,
    );
  }
}
