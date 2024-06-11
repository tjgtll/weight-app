import 'package:charts_flutter_new/flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight/models/weight_data.dart';
import 'package:weight/services/weight_repository.dart';

class SimpleTimeSeriesChart extends StatelessWidget {
  final bool _animate = true;
  final bool _defaultInteractions = false;
  final bool _includeArea = false;
  final bool _includePoints = false;
  final bool _stacked = false;

  const SimpleTimeSeriesChart({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> dashPattern = [5, 2];
    var weightDataRepository = Provider.of<WeightDataRepository>(context);
    var weightData = weightDataRepository.weightData;
    if (weightData.isEmpty) {
      // You can return a placeholder widget or an empty container,
      // or handle this case in any other appropriate way.
      return Container(); // Empty container
    }
    final List<Series<WeightData, DateTime>> seriesList = [
      Series<WeightData, DateTime>(
        id: 'Weight',
        data: weightDataRepository.weightData
            .map((weightData) =>
                WeightData(date: weightData.date, weight: weightData.weight))
            .toList(),
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (WeightData weight, _) => weight.date,
        measureFn: (WeightData weight, _) => weight.weight,
      ),
      Series<WeightData, DateTime>(
        id: 'Avg',
        data: weightDataRepository.y
            .map((weightData) =>
                WeightData(date: weightData.date, weight: weightData.weight))
            .toList(),
        domainFn: (WeightData avg, _) => avg.date,
        measureFn: (WeightData avg, _) => avg.weight,
        colorFn: (_, __) => MaterialPalette.red.shadeDefault,
        dashPatternFn: (_, __) => dashPattern,
      ),
      Series<WeightData, DateTime>(
        id: 'Target',
        data: weightDataRepository.y
            .map((weightData) => WeightData(
                date: weightData.date, weight: weightDataRepository.x))
            .toList(),
        domainFn: (WeightData other, _) => other.date,
        measureFn: (WeightData other, _) => other.weight,
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        dashPatternFn: (_, __) => dashPattern,
      ),
    ];
    int customMinWeight = weightDataRepository.minWeight.toInt();
    int customMaxWeight = weightDataRepository.maxWeight.toInt();
    return TimeSeriesChart(
      seriesList,
      dateTimeFactory: const LocalDateTimeFactory(),
      defaultInteractions: _defaultInteractions,
      defaultRenderer: LineRendererConfig(
        includePoints: _includePoints,
        includeArea: _includeArea,
        stacked: _stacked,
      ),
      animate: _animate,
      domainAxis: DateTimeAxisSpec(
        viewport: DateTimeExtents(
          start: weightDataRepository.minDate,
          end: weightDataRepository.lastDate,
        ),
        tickFormatterSpec: const AutoDateTimeTickFormatterSpec(
          day: TimeFormatterSpec(
            format: 'dd.MM',
            transitionFormat: 'dd',
          ),
          month: TimeFormatterSpec(
            format: 'MM.yy',
            transitionFormat: 'MM.yy',
          ),
          year: TimeFormatterSpec(
            format: 'd',
            transitionFormat: 'yyyy',
          ),
        ),
        renderSpec: const GridlineRendererSpec(),
      ),
      primaryMeasureAxis: NumericAxisSpec(
        viewport: NumericExtents.fromValues([customMinWeight, customMaxWeight]),
      ),
    );
  }
}
