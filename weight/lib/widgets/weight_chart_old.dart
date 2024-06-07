import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:weight/models/weight_data.dart';
import 'package:weight/services/weight_repository.dart';

var style10 = const TextStyle(fontSize: 10);

class WeightChart extends StatefulWidget {
  final WeightDataRepository weightDataRepository;

  const WeightChart({
    super.key,
    required this.weightDataRepository,
  });

  @override
  _WeightChartState createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {
  late final WeightDataRepository _weightDataRepository;
  @override
  void initState() {
    _weightDataRepository = widget.weightDataRepository;

    super.initState();
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    if (value == _weightDataRepository.firstDate ||
        value == _weightDataRepository.lastDate) {
      return const SizedBox();
    }
    var result = SideTitleWidget(
        axisSide: meta.axisSide,
        space: 8,
        child: Text(
          DateFormat('MM.yy').format(DateTime.fromMillisecondsSinceEpoch(
            value.toInt(),
          )),
          style: style10,
        ));

    return result;
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    var result = SideTitleWidget(
        axisSide: meta.axisSide,
        space: 4,
        child: Text(
          value.toInt().toString(),
          style: style10,
        ));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WeightData>>(
        future: _weightDataRepository.calc(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Ошибка загрузки данных'));
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: LineChart(
                curve: Curves.easeIn,
                LineChartData(
                  clipData: const FlClipData.all(),
                  extraLinesData: const ExtraLinesData(extraLinesOnTop: true),
                  minY: _weightDataRepository.minWeight,
                  maxY: _weightDataRepository.maxWeight,
                  gridData: const FlGridData(
                    horizontalInterval: 10,
                    drawVerticalLine: false,
                  ),
                  minX: _weightDataRepository.weightData.isNotEmpty
                      ? _weightDataRepository
                          .weightData.first.date.millisecondsSinceEpoch
                          .toDouble()
                      : 0,
                  maxX: _weightDataRepository.weightData.isNotEmpty
                      ? _weightDataRepository
                          .weightData.last.date.millisecondsSinceEpoch
                          .toDouble()
                      : 0,
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: getLeftTitles,
                    )),
                    rightTitles: const AxisTitles(),
                    bottomTitles: const AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 22,
                      //getTitlesWidget: getBottomTitles,
                    )),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    // LineChartBarData(
                    //   spots: _weightDataRepository.y
                    //       .map((y) => FlSpot(y, _weightDataRepository.x))
                    //       .toList(),
                    //   isCurved: false,
                    //   color: Colors.red,
                    //   barWidth: 2,
                    //   isStrokeCapRound: false,
                    //   isStepLineChart: true,
                    //   dotData: const FlDotData(show: false),
                    //   belowBarData: BarAreaData(show: false),
                    //   dashArray: [5, 3],
                    // ),
                    // LineChartBarData(
                    //   spots: _weightDataRepository.y
                    //       .map((y) => FlSpot(y, _weightDataRepository.avg))
                    //       .toList(),
                    //   isCurved: false,
                    //   color: Colors.green,
                    //   barWidth: 2,
                    //   isStrokeCapRound: false,
                    //   dotData: const FlDotData(show: false),
                    //   belowBarData: BarAreaData(show: false),
                    //   dashArray: [5, 3],
                    // ),
                    LineChartBarData(
                      spots: _weightDataRepository.weightData
                          .map((data) => FlSpot(
                              data.date.millisecondsSinceEpoch.toDouble(),
                              data.weight))
                          .toList(),
                      isCurved: false,
                      color: Colors.blue,
                      barWidth: 2,
                      isStrokeCapRound: false,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: false,
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('Нет данных'));
          }
        });
  }
}
