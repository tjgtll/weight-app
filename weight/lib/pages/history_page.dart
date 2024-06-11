import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight/database/weight_db.dart';
import 'package:weight/models/weight_data.dart';
import 'package:weight/services/weight_repository.dart';
import 'package:weight/widgets/weight_form/edit_weight_form.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPage createState() => _HistoryPage();
}

class _HistoryPage extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var weightDataRepository = Provider.of<WeightDataRepository>(context);

    return FutureBuilder<List<WeightData>>(
      future: weightDataRepository.futureWeights,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Ошибка загрузки данных'));
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final currentData = snapshot.data![index];
              final currentWeight = currentData.weight;
              double? weightDiff;
              if (index < weightDataRepository.length - 1) {
                final prevData = snapshot.data![index + 1];
                final prevWeight = prevData.weight;
                weightDiff = -(currentWeight - prevWeight);
              }
              return _buildRow(currentData, weightDiff, weightDataRepository);
            },
          );
        } else {
          return const Center(child: Text('Нет данных'));
        }
      },
    );
  }

  Widget _buildRow(WeightData weightData, double? weightDiff,
      WeightDataRepository weightDataRepository) {
    String formattedDate =
        '${weightData.date.day.toString().padLeft(2, '0')}.${weightData.date.month.toString().padLeft(2, '0')}.${weightData.date.year}';

    Color diffColor = Colors.black;
    String diffText = "0.00 кг";

    if (weightDiff != null) {
      diffText =
          '${weightDiff > 0 ? '' : '+'}${weightDiff.abs().toStringAsFixed(1)} кг';
      if (weightDiff != 0) {
        diffColor = weightDiff > 0 ? Colors.green : Colors.red;
      }
    }

    return InkWell(
      onTap: () {
        editDialogBuilder(context, weightData, weightDataRepository);
      },
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 90,
                  child: Text(
                    formattedDate,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    '${weightData.weight} кг',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    diffText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: diffColor, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
            height: 0,
          ),
        ],
      ),
    );
  }
}
