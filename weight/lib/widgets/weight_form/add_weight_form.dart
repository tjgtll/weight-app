import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';
import 'package:weight/services/weight_repository.dart';

class IntegerExample extends StatefulWidget {
  final ValueChanged<_IntegerExampleState>? onStateChange;
  final WeightDataRepository weightDataRepository;

  const IntegerExample({
    super.key,
    this.onStateChange,
    required this.weightDataRepository,
  });

  @override
  _IntegerExampleState createState() => _IntegerExampleState();
}

class _IntegerExampleState extends State<IntegerExample> {
  int _kilo = 0;
  int _gramms = 0;

  @override
  void initState() {
    var lastWeight = widget.weightDataRepository.lastWeight;
    _kilo = lastWeight.toInt();
    _gramms = ((lastWeight - lastWeight.toInt()) * 10).toInt();
    super.initState();
    widget.onStateChange?.call(this);
  }

  void updateKilo(int value) {
    setState(() {
      _kilo = value;
    });
    widget.onStateChange?.call(this);
  }

  void updateGramms(int value) {
    setState(() {
      _gramms = value;
    });
    widget.onStateChange?.call(this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NumberPicker(
              itemWidth: 50,
              textStyle: const TextStyle(fontSize: 18),
              selectedTextStyle:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              value: _kilo,
              minValue: 0,
              maxValue: 900,
              onChanged: updateKilo,
            ),
            const Text("."),
            NumberPicker(
              infiniteLoop: true,
              itemWidth: 50,
              textStyle: const TextStyle(fontSize: 18),
              selectedTextStyle:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              value: _gramms,
              minValue: 0,
              maxValue: 9,
              onChanged: updateGramms,
            ),
            const Text("кг"),
          ],
        ),
      ],
    );
  }

  double get weight => _kilo + (_gramms / 10);
}

Future<void> addDialogBuilder(
    BuildContext context, WeightDataRepository weightDataRepository) {
  _IntegerExampleState? integerState;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.blue,
        backgroundColor: Colors.white,
        title: const Text('Вес'),
        content: IntegerExample(
          onStateChange: (state) {
            integerState = state;
          },
          weightDataRepository: weightDataRepository,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('dd.MM.yyyy').format(DateTime.now())),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('ОТМЕНА'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('ОК'),
                    onPressed: () {
                      weightDataRepository.add(
                          DateTime.now(), integerState!.weight);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    },
  );
}
