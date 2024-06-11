import 'package:flutter/material.dart';
import 'package:weight/services/weight_repository.dart';
import 'package:weight/services/person_repository.dart';
import 'package:weight/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:weight/database/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WeightDataRepository>(
          create: (_) => WeightDataRepository(),
        ),
        ChangeNotifierProvider<PersonDataRepository>(
          create: (_) => PersonDataRepository(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weight Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: const HomePage(
          title: 'Flutter Demo Home Page',
        ),
      ),
    );
  }
}
