import 'package:weight/models/person_data.dart';
import 'package:weight/database/person_db.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class PersonDataRepository extends ChangeNotifier {
  PersonData? _personData;
  final PersonDB _personDB = PersonDB();

  PersonData? get personData => _personData;

  PersonDataRepository() {
    loadPersonData();
  }

  Future<void> loadPersonData() async {
    final persons = await _personDB.fetchAll();
    if (persons.isNotEmpty) {
      _personData = persons.first;
      print(persons.first.id);
      notifyListeners();
    }
    print("loadPersonData");
  }

  Future<void> addOrUpdatePersonData(PersonData personData) async {
    final existingPerson = await _personDB.fetchById(personData.id);
    if (existingPerson == null) {
      await _personDB.create(personData: personData);
    } else {
      await _personDB.update(personData: personData);
    }
    _personData = personData;
    notifyListeners();
  }

  Future<void> updateHeight(double height) async {
    if (_personData != null) {
      _personData = PersonData(
        id: _personData!.id,
        height: height,
        gender: _personData!.gender,
        age: _personData!.age,
        requiredWeight: _personData!.requiredWeight,
      );
      await _personDB.update(personData: _personData!);
      notifyListeners();
    }
  }

  Future<void> updateAge(int age) async {
    if (_personData != null) {
      _personData = PersonData(
        id: _personData!.id,
        height: _personData!.height,
        gender: _personData!.gender,
        age: age,
        requiredWeight: _personData!.requiredWeight,
      );
      await _personDB.update(personData: _personData!);
      notifyListeners();
    }
  }

  Future<void> updateGender(String gender) async {
    if (_personData != null) {
      _personData = PersonData(
        id: _personData!.id,
        height: _personData!.height,
        gender: gender,
        age: _personData!.age,
        requiredWeight: _personData!.requiredWeight,
      );
      await _personDB.update(personData: _personData!);
      notifyListeners();
    }
  }

  Future<void> updateRequiredWeight(double requiredWeight) async {
    if (_personData != null) {
      _personData = PersonData(
        id: _personData!.id,
        height: _personData!.height,
        gender: _personData!.gender,
        age: _personData!.age,
        requiredWeight: requiredWeight,
      );
      await _personDB.update(personData: _personData!);
      notifyListeners();
    }
  }

  Future<void> deletePersonData() async {
    if (_personData != null) {
      await _personDB.delete(_personData!.id);
      _personData = null;
      notifyListeners();
    }
  }
}
