import 'package:flutter/services.dart' show rootBundle;
import 'package:weight/models/weight_data.dart';

class CSVService {
  Future<List<WeightData>> loadCSV() async {
    return _loadCSV();
  }

  Future<List<WeightData>> _loadCSV() async {
    final csvString = await rootBundle.loadString('assets/data.csv');

    final Iterable<String> lines =
        csvString.split('\n').skip(1).toList().reversed;
    final List<List<dynamic>> csvDataList =
        lines.map((line) => line.split(',')).toList();

    List<WeightData> weightData = [];
    for (var csvData in csvDataList) {
      final date = DateTime.parse(csvData[0]);
      final weight = double.parse(csvData[1].toString());
      weightData.add(WeightData(date: date, weight: weight));
    }
    return weightData;
  }

  // Future<void> loadWeightDataFromCSV() async {
  //   try {
  //     List<WeightData> list = await csvService.loadCSV();

  //     for (var item in list) {
  //       weightDB.create(weightData: item);
  //       print('Date: ${item.date}, Weight: ${item.weight}');
  //     }
  //   } catch (e) {
  //     print('Error loading data from CSV: $e');
  //   }
  // }
}
