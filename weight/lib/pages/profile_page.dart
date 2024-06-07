import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isFemaleSelected = false;
  bool isMaleSelected = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Row(
            children: [],
          ),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
          const Row(
            children: [
              GenderToggleButton(),
            ],
          ),
          const Text("Обшие"),
          Container(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: "Возраст"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                TextField(
                  decoration: const InputDecoration(labelText: "Рост"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                TextField(
                  decoration: const InputDecoration(labelText: "Требуеый вес"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ],
            ),
          ),
          const Text("Резервир. и восстановить"),
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.blue))),
              minimumSize: MaterialStateProperty.all<Size>(
                  const Size(double.infinity, 48)),
              fixedSize: MaterialStateProperty.all<Size>(const Size(48, 48)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
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
              fixedSize: MaterialStateProperty.all<Size>(const Size(48, 48)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
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
  }
}

class GenderToggleButton extends StatefulWidget {
  const GenderToggleButton({super.key});

  @override
  _GenderToggleButtonState createState() => _GenderToggleButtonState();
}

class _GenderToggleButtonState extends State<GenderToggleButton> {
  bool isMaleSelected = true;

  void toggleGender() {
    setState(() {
      isMaleSelected = !isMaleSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleGender,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                MdiIcons.humanMale,
                size: 50,
                color: isMaleSelected ? Colors.blue : Colors.grey,
              ),
              Icon(
                MdiIcons.humanFemale,
                size: 50,
                color: !isMaleSelected ? Colors.blue : Colors.grey,
              ),
            ],
          )
        ],
      ),
    );
  }
}
