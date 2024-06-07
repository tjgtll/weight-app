class PersonData {
  final String name;
  final double height;
  final String gender;

  PersonData({required this.name, required this.height, required this.gender});

  factory PersonData.fromSqfliteDatabase(Map<String, dynamic> data) {
    return PersonData(
      name: data['name'],
      height: data['height'],
      gender: data['gender'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'height': height,
      'gender': gender,
    };
  }
}
