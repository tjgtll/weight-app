class PersonData {
  final int? id;
  final double requiredWeight;
  final double height;
  final int age;
  final String gender;

  PersonData(
      {this.id,
      required this.requiredWeight,
      required this.height,
      required this.age,
      required this.gender});

  factory PersonData.fromSqfliteDatabase(Map<String, dynamic> data) {
    return PersonData(
      id: data['id'],
      requiredWeight: data['requiredWeight'],
      height: data['height'],
      age: data['age'],
      gender: data['gender'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requiredWeight': requiredWeight,
      'height': height,
      'age': age,
      'gender': gender,
    };
  }
}
