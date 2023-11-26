class PlanModel {
  String planId;
  String tripId;

  PlanModel({
    required this.planId,
    required this.tripId,
  });

  PlanModel copyWith({
    String? planId,
    String? tripId,
  }) {
    return PlanModel(
      planId: planId ?? this.planId,
      tripId: tripId ?? this.tripId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'planId': planId,
      'tripID': tripId,
    };
  }

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      planId: map['planId'] as String,
      tripId: map['tripId'] as String,
    );
  }
}
