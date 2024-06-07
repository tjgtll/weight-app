import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight/widgets/weight_form/add_weight_form.dart';
import 'package:weight/widgets/button_panerl_item.dart';
import 'package:buttons_panel/buttons_panel.dart';
import 'package:weight/pages/review_page.dart';
import 'package:weight/pages/statistics_page.dart';
import 'package:weight/pages/history_page.dart';
import 'package:weight/pages/profile_page.dart';
import 'package:weight/services/weight_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentIndex = 0;
  String _selectedOption = 'ВСЕ';

  @override
  Widget build(BuildContext context) {
    Widget page;
    String title;
    var weightDataRepository = Provider.of<WeightDataRepository>(context);
    switch (currentIndex) {
      case 0:
        page = const ReviewPage();
        title = "Обзор";
        break;
      case 1:
        page = const StatisticsPage();
        title = "Статистика";
        break;
      case 2:
        page = const HistoryPage();
        title = "История";
        break;
      case 3:
        page = const ProfilePage();
        title = "Профиль";
        break;
      default:
        throw UnimplementedError('Ошибка $currentIndex');
    }

    switch (_selectedOption) {
      case '2 недели':
        weightDataRepository.minDate = weightDataRepository.dateAgo(0, 14);
        break;
      case '1 месяц':
        weightDataRepository.minDate = weightDataRepository.dateAgo(1, 0);
        break;
      case '3 месяца':
        weightDataRepository.minDate = weightDataRepository.dateAgo(3, 0);
        break;
      case '6 месяцев':
        weightDataRepository.minDate = weightDataRepository.dateAgo(6, 0);
        break;
      case '1 год':
        weightDataRepository.minDate = weightDataRepository.dateAgo(12, 0);
        break;
      case 'ВСЕ':
        weightDataRepository.minDate = weightDataRepository.firstDate;
        break;
      default:
        weightDataRepository.minDate = weightDataRepository.firstDate;
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.blue[300],
          surfaceTintColor: Colors.white,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          actions: currentIndex == 0
              ? [
                  PopupMenuButton<String>(
                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.blue,
                    onSelected: (value) {
                      setState(() {
                        _selectedOption = value;
                      });
                      weightDataRepository.updateData();
                    },
                    shape: null,
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: '2 недели',
                        child: Text('2 недели'),
                      ),
                      const PopupMenuItem<String>(
                        value: '1 месяц',
                        child: Text('1 месяц'),
                      ),
                      const PopupMenuItem<String>(
                        value: '3 месяца',
                        child: Text('3 месяца'),
                      ),
                      const PopupMenuItem<String>(
                        value: '6 месяцев',
                        child: Text('6 месяцев'),
                      ),
                      const PopupMenuItem<String>(
                        value: '1 год',
                        child: Text('1 год'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'ВСЕ',
                        child: Text('ВСЕ'),
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            _selectedOption,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              : null,
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: page,
          ),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
        floatingActionButton: currentIndex == 0
            ? SizedBox(
                width: 60.0,
                height: 60.0,
                child: FloatingActionButton(
                  backgroundColor: Colors.blue[300],
                  splashColor: Colors.blue,
                  hoverColor: Colors.blue,
                  focusColor: Colors.blue,
                  onPressed: () =>
                      addDialogBuilder(context, weightDataRepository),
                  tooltip: 'Добавить вес',
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: ButtonsPanel(
          currentIndex: currentIndex,
          backgroundColor: Colors.white,
          selectedItemBackgroundColor: Colors.white,
          selectedIconThemeData:
              const IconThemeData(color: Color.fromRGBO(100, 181, 246, 1)),
          selectedTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(100, 181, 246, 1),
          ),
          unselectedIconThemeData: const IconThemeData(color: Colors.grey),
          unselectedTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          onTap: (value) => setState(() {
            currentIndex = value;
          }),
          children: [
            buildButtonPanelItem(Icons.home, 'Обзор'),
            buildButtonPanelItem(Icons.bar_chart, 'Статистика'),
            buildButtonPanelItem(Icons.history, 'История'),
            buildButtonPanelItem(Icons.person, 'Профиль'),
          ],
        ),
      );
    });
  }
}
