import 'package:flutter/material.dart';
import 'package:weight/services/weight_repository.dart';
import 'package:weight/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WeightDataRepository weightDataRepository = WeightDataRepository();
    return ChangeNotifierProvider(
      create: (_) => weightDataRepository,
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
