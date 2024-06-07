class WeightData {
  final DateTime date;
  final double weight;

  WeightData({
    required this.date,
    required this.weight,
  });

  factory WeightData.fromSqfliteDatabase(Map<String, dynamic> map) =>
      WeightData(
        date: DateTime.fromMillisecondsSinceEpoch(map['date']),
        weight: map['weight'].toDouble(),
      );
}
