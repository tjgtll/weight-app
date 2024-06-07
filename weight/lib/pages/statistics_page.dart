import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight/services/weight_repository.dart';
import 'package:weight/widgets/custom_prety_gauge.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({
    super.key,
  });

  @override
  State<StatisticsPage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<StatisticsPage> {
  double? bmi;
  String errorText = '';
  String status = '';
  @override
  void initState() {
    super.initState();
  }

  Widget _textBuild(String text, String parameter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        Text(
          parameter,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _labelBuild(String text) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      const Divider(
        color: Color.fromARGB(255, 207, 206, 206),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var weightDataRepository = Provider.of<WeightDataRepository>(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _labelBuild("Тенденции"),
          _textBuild("Динамика за посл. 7 дней",
              "${weightDataRepository.weightChangeWeek().toStringAsFixed(1)} кг"),
          _textBuild("Динамика за посл. 30 дней",
              "${weightDataRepository.weightChangeMonth().toStringAsFixed(1)} кг"),
          const SizedBox(
            height: 20,
          ),
          _labelBuild("ИМТ"),
          Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    PrettyGauge(
                      showMarkers: true,
                      gaugeSize: 75,
                      minValue: 16,
                      maxValue: 40,
                      segments: [
                        GaugeSegment('UnderWeight', 2.5, Colors.blue),
                        GaugeSegment('Normal', 6.5, Colors.green),
                        GaugeSegment('Pre obesity', 5, Colors.yellow),
                        GaugeSegment('OverWeight', 5, Colors.orange),
                        GaugeSegment('Obese', 5, Colors.red),
                      ],
                      valueWidget: Text(
                        weightDataRepository
                            .getWeightDMI(weightDataRepository.lastWeight, 175)
                            .toStringAsFixed(1),
                        style: const TextStyle(fontSize: 20),
                      ),
                      currentValue: weightDataRepository.getWeightDMI(
                          weightDataRepository.lastWeight, 187),
                      needleColor: Colors.blue,
                    ),
                  ])),
          _textBuild("Категория", weightDataRepository.getState(187)),
          _textBuild("Нормальный вес",
              "${weightDataRepository.getNormalLowerWeight(187).toStringAsFixed(1)} - ${weightDataRepository.getNormalUpperWeight(187).toStringAsFixed(1)} кг"),
          _textBuild("Отклонение",
              "${weightDataRepository.weightDeviation(187).toStringAsFixed(2)} кг"),
          const SizedBox(
            height: 20,
          ),
          _labelBuild("Прогресс"),
          _textBuild("Среднее изменение за неделю",
              "${weightDataRepository.avgPerWeek().toStringAsFixed(2)} кг"),
          _textBuild("Среднее изменение за месяц",
              "${weightDataRepository.avgPerMonth().toStringAsFixed(2)} кг"),
          _textBuild("Чисдо дней до дистижения цели",
              "${weightDataRepository.weightDayToTarget(187)}"),
          const SizedBox(
            height: 20,
          ),
          _labelBuild("В целом"),
          _textBuild("Средний", "${weightDataRepository.avg} кг"),
          _textBuild(
              "Рекорд (максимум)", "${weightDataRepository.maxWeightC} кг"),
          _textBuild(
              "Рекорд (минимум)", "${weightDataRepository.minWeightC} кг"),
          _textBuild("Измерения", "${weightDataRepository.length}"),
          Text(
            errorText,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
