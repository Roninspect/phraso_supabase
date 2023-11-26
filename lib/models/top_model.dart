class TypesOfPhrasesmodel {
  int id;
  String name;
  String color;
  String icon;
  TypesOfPhrasesmodel({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  TypesOfPhrasesmodel copyWith({
    int? id,
    String? name,
    String? color,
    String? icon,
  }) {
    return TypesOfPhrasesmodel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'color': color,
      'icon': icon,
    };
  }

  factory TypesOfPhrasesmodel.fromMap(Map<String, dynamic> map) {
    return TypesOfPhrasesmodel(
      id: map['id'] as int,
      name: map['name'] as String,
      color: map['color'] as String,
      icon: map['icon'] as String,
    );
  }
}
