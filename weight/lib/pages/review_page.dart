import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight/widgets/weight_chart.dart';
import 'package:weight/widgets/text_colored_box.dart';
import 'package:weight/services/weight_repository.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var weightDataRepository = Provider.of<WeightDataRepository>(context);

    return Consumer<WeightDataRepository>(
      builder: (context, s, _) {
        return FutureBuilder(
          future: weightDataRepository.futureWeights,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Ошибка загрузки данных'));
            } else if (snapshot.hasData) {
              if (weightDataRepository.weightData.isEmpty) {
                return const Center(child: Text('Нет данных'));
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildTextWithSubtext(
                          "Начальный", weightDataRepository.firstWeight),
                      _buildTextWithSubtext(
                          "Текущий", weightDataRepository.lastWeight,
                          style: const TextStyle(
                              color: Colors.blue, fontSize: 16)),
                      _buildTextWithSubtext("Целевой", weightDataRepository.x),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        textWithColorBox("вес", Colors.blue),
                        textWithColorBox("средний", Colors.green),
                        textWithColorBox("целевой", Colors.red),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: SimpleTimeSeriesChart(),
                  ),
                  SizedBox(
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTextWithSubtext("Изменение",
                                weightDataRepository.weightChange()),
                            _buildTextWithSubtext("Осталось",
                                weightDataRepository.weightToTarget()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('Нет данных'));
            }
          },
        );
      },
    );
  }
}

Widget _buildTextWithSubtext(String text, double subtext,
    {TextStyle? style = const TextStyle(color: Colors.black, fontSize: 16)}) {
  return Column(
    children: [
      SizedBox(
        width: 100,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
      Text(
        '${subtext.toStringAsFixed(1)} кг',
        textAlign: TextAlign.center,
        style: style,
      ),
    ],
  );
}
