import 'package:flutter/material.dart';
import 'package:weight/services/person_repository.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isMaleSelected = false;
  double requiredWeight = 50;

  late TextEditingController _heightController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    final personDataRepository =
        Provider.of<PersonDataRepository>(context, listen: false);
    _heightController = TextEditingController(
      text: personDataRepository.personData?.height.toString() ?? '',
    );
    _ageController = TextEditingController(
      text: personDataRepository.personData?.age.toString() ?? '',
    );
    requiredWeight = personDataRepository.personData?.requiredWeight ?? 50;
    _weightController = TextEditingController(
      text: requiredWeight.toStringAsFixed(1),
    );

    isMaleSelected = personDataRepository.isMale();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonDataRepository>(
      builder: (context, personDataRepository, child) {
        _heightController.text =
            personDataRepository.personData?.height.toString() ?? '';
        _ageController.text =
            personDataRepository.personData?.age.toString() ?? '';
        requiredWeight = personDataRepository.personData?.requiredWeight ?? 50;
        _weightController.text = requiredWeight.toStringAsFixed(1);

        isMaleSelected = personDataRepository.isMale();
        return SingleChildScrollView(
          child: Column(
            children: [
              const Text("Обшие"),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _heightController,
                          decoration: const InputDecoration(labelText: "Рост"),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              personDataRepository
                                  .updateHeight(double.parse(value));
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isMaleSelected = true;
                          });
                          personDataRepository.updateGender('Male');
                        },
                        child: Icon(
                          MdiIcons.humanMale,
                          size: 50,
                          color: isMaleSelected ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ageController,
                          decoration:
                              const InputDecoration(labelText: "Возраст"),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              personDataRepository.updateAge(int.parse(value));
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isMaleSelected = false;
                          });
                          personDataRepository.updateGender('Female');
                        },
                        child: Icon(
                          MdiIcons.humanFemale,
                          size: 50,
                          color: !isMaleSelected ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _weightController,
                    decoration:
                        const InputDecoration(labelText: "Требуемый вес"),
                    readOnly: true,
                    onTap: () async {
                      double? selectedWeight = await showDialog<double>(
                        context: context,
                        builder: (context) =>
                            WeightPickerDialog(initialWeight: requiredWeight),
                      );

                      if (selectedWeight != null) {
                        setState(() {
                          requiredWeight = selectedWeight;
                          _weightController.text =
                              selectedWeight.toStringAsFixed(1);
                          personDataRepository
                              .updateRequiredWeight(selectedWeight);
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Резервир. и восстановить"),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide(color: Colors.blue))),
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 48)),
                  fixedSize:
                      MaterialStateProperty.all<Size>(const Size(48, 48)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.blue.withOpacity(0.04);
                      }
                      if (states.contains(MaterialState.focused) ||
                          states.contains(MaterialState.pressed)) {
                        return Colors.blue.withOpacity(0.12);
                      }
                      return null;
                    },
                  ),
                ),
                child: const Text("Экспорт в файл CSV"),
                onPressed: () => {},
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide(
                              color: Color.fromARGB(255, 163, 186, 205)))),
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 48)),
                  fixedSize:
                      MaterialStateProperty.all<Size>(const Size(48, 48)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.blue.withOpacity(0.04);
                      }
                      if (states.contains(MaterialState.focused) ||
                          states.contains(MaterialState.pressed)) {
                        return Colors.blue.withOpacity(0.12);
                      }
                      return null;
                    },
                  ),
                ),
                child: const Text("Импорт из файла CSV"),
                onPressed: () => {},
              ),
              const Text(
                "develop by Volod1n (version 0.0.1)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.grey),
              )
            ],
          ),
        );
      },
    );
  }
}

class WeightPickerDialog extends StatefulWidget {
  final double initialWeight;

  const WeightPickerDialog({super.key, required this.initialWeight});

  @override
  _WeightPickerDialogState createState() => _WeightPickerDialogState();
}

class _WeightPickerDialogState extends State<WeightPickerDialog> {
  late int _kilo;
  late int _gramms;

  @override
  void initState() {
    super.initState();
    _kilo = widget.initialWeight.toInt();
    _gramms = ((widget.initialWeight - _kilo) * 10).toInt();
  }

  void updateKilo(int value) {
    setState(() {
      _kilo = value;
    });
  }

  void updateGramms(int value) {
    setState(() {
      _gramms = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Weight'),
      content: Column(
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
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(_kilo + (_gramms / 10));
          },
        ),
      ],
    );
  }
}

class IntegerExample extends StatefulWidget {
  final ValueChanged<_IntegerExampleState>? onStateChange;
  final PersonDataRepository personDataRepository;

  const IntegerExample({
    super.key,
    this.onStateChange,
    required this.personDataRepository,
  });

  @override
  _IntegerExampleState createState() => _IntegerExampleState();
}

class _IntegerExampleState extends State<IntegerExample> {
  int _kilo = 0;
  int _gramms = 0;

  @override
  void initState() {
    var lastWeight =
        widget.personDataRepository.personData?.requiredWeight ?? 0;

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
