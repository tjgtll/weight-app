import 'package:weight/models/weight_data.dart';
import 'package:weight/database/weight_db.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class WeightDataRepository extends ChangeNotifier {
  double avg = 0;
  double x = 100;
  double minWeight = 0;
  double maxWeight = 0;
  double minWeightC = 0;
  double maxWeightC = 0;
  final weightDB = WeightDB();
  DateTime minDate = DateTime.now();
  List<WeightData> _weightData = [];

  List<WeightData> _y = [];
  int get length => _weightData.length;
  double get lastWeight =>
      _weightData.isEmpty ? 0 : _weightData.last.weight.toDouble();
  double get firstWeight =>
      _weightData.isEmpty ? 0 : _weightData.first.weight.toDouble();
  DateTime get firstDate =>
      _weightData.isEmpty ? DateTime.now() : _weightData.first.date;
  DateTime get lastDate =>
      _weightData.isEmpty ? DateTime.now() : _weightData.last.date;
  List<WeightData> get weightData => _weightData;
  List<WeightData> get y => _y;
  Future<List<WeightData>>? futureWeights;

  WeightDataRepository() {
    loadWeightData();
    updateData();
  }

  void setMinDate(DateTime dateTime) {
    minDate = dateTime;
    updateData();
  }

  void updateData() {
    calc();
    notifyListeners();
  }

  void loadWeightData() async {
    futureWeights = weightDB.fetchAll();
  }

  Future<List<WeightData>> calc() async {
    futureWeights?.then((data) {
      _weightData = data.reversed.toList();
    });
    _y = [];
    double sum = 0;
    double count = 0;

    double min = double.maxFinite;
    double max = double.minPositive;

    for (var item in _weightData) {
      final weight = item.weight;
      if (min > weight) min = item.weight;
      if (max < weight) max = item.weight;
      sum += weight;
      count++;
    }
    maxWeightC = max;
    minWeightC = min;
    maxWeight = ((max + 5) ~/ 5) * 5;
    minWeight = ((min) ~/ 5) * 5;
    avg = double.parse((sum / count).toStringAsFixed(1));
    DateTime firstDate = _weightData.first.date;
    DateTime lastDate = _weightData.last.date;
    _y.add(WeightData(date: firstDate, weight: avg));
    _y.add(WeightData(date: lastDate, weight: avg));

    return _weightData;
  }

  Future<void> update(WeightData weightData) {
    weightDB.update(weightData: weightData);
    futureWeights = weightDB.fetchAll();
    updateData();
    return Future.value();
  }

  Future<void> add(DateTime date, double weight) {
    var w = WeightData(date: date, weight: weight);
    if (isSameDay(_weightData.last.date, date)) {
      update(WeightData(date: _weightData.last.date, weight: weight));
      return Future.value();
    }
    if (_weightData.isNotEmpty) {
      var lastDate = _weightData.last.date;
      if (lastDate.year == date.year &&
          lastDate.month == date.month &&
          lastDate.day == date.day) {
        _weightData.removeLast();
      }
    }
    weightDB.create(weightData: w);
    _weightData.add(w);
    futureWeights = weightDB.fetchAll();
    updateData();
    return Future.value();
  }

  Future<void> delete(WeightData weight) {
    weightDB.delete(weight.date);
    _weightData.remove(weight);
    futureWeights = weightDB.fetchAll();
    updateData();
    return Future.value();
  }

  double avgPerMonth() => _avgPerDays(30.4);

  double avgPerWeek() => _avgPerDays(7);

  String getState(double height) {
    var bmi = _calculateBMI(lastWeight, height);
    String status;
    if (bmi < 18.5) {
      status = "Ниже нормы";
    } else if (bmi > 18.5 && bmi < 25) {
      status = 'Нормальный вес';
    } else if (bmi > 25 && bmi < 30) {
      status = 'Пред ожирение';
    } else if (bmi > 30 && bmi < 35) {
      status = 'Ожирение Класс 1';
    } else if (bmi > 35 && bmi < 40) {
      status = 'Ожирение Класс 2';
    } else {
      status = 'Ожирение Класс 3';
    }
    return status;
  }

  double getNormalLowerWeight(double height) => _getWeightDMI(height, 18.5);

  double getNormalUpperWeight(double height) => _getWeightDMI(height, 24.9);

  double weightChange() => _weightData.last.weight - _weightData.first.weight;

  double weightChangeMonth() => _weightChangeDays(30);

  double weightChangeWeek() => _weightChangeDays(7);

  double weightDeviation(double height) {
    if (_weightData.isEmpty) return 0;
    if (getNormalLowerWeight(height) > _weightData.last.weight) {
      return getNormalLowerWeight(height) - _weightData.last.weight;
    }
    if (getNormalUpperWeight(height) < _weightData.last.weight) {
      return getNormalUpperWeight(height) - _weightData.last.weight;
    }
    return 0;
  }

  double weightToTarget() => x - _weightData.last.weight;

  int weightDayToTarget(double height) {
    var weightChange = weightChangeWeek();
    if (weightChange == 0) {
      weightChange = weightChangeMonth();
    }
    var deviaton = weightDeviation(height);
    if (weightChange == 0 || deviaton == 0) return 0;
    var result = ((deviaton / weightChange) * 30).toInt();
    return result < 0 ? 0 : result;
  }

  //надо перенести
  DateTime dateAgo(int month, int days) {
    var date = DateTime.now();
    return DateTime(date.year, date.month - month, date.day - days);
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  double _getWeightDMI(double height, double bmi) {
    return bmi * pow((height / 100), 2).toDouble();
  }

  double getWeightDMI(double weight, double height) {
    return weight / pow((height / 100), 2);
  }

  double _avgPerDays(double days) {
    var count = (lastDate.difference(firstDate).inDays / days).ceil();
    return ((lastWeight - firstWeight) / count);
  }

  double _weightChangeDays(int days) {
    if (_weightData.isEmpty) return 0;
    var thirtyDaysAgo = DateTime.now().subtract(Duration(days: days));
    var result = weightData.firstWhere(
        (data) => data.date.isAfter(thirtyDaysAgo),
        orElse: () => weightData.last);

    return result.weight - weightData.last.weight;
  }

  double _calculateBMI(double weight, double height) {
    var heightInMeters = height / 100;
    var bmi = weight / (pow(heightInMeters, 2));
    return bmi;
  }
}
