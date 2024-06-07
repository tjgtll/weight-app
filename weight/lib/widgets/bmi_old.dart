import 'package:flutter/material.dart';

Widget bmiOldWidget(BuildContext context, String status, double? bmi) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 300,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade400,
        )),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                bmi == null ? '00.00' : bmi.toStringAsFixed(2),
                style: TextStyle(
                    fontSize: 60,
                    color: status == 'Ниже нормы'
                        ? Colors.blue
                        : status == 'Нормальный'
                            ? Colors.green
                            : status == 'Pre-Obesity'
                                ? Colors.yellow.shade700
                                : status == 'Obesity class 1'
                                    ? Colors.orange
                                    : status == 'Obesity class 2'
                                        ? Colors.deepOrangeAccent
                                        : status == 'Obesity class 3'
                                            ? Colors.red
                                            : null),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                        color: status == 'Underweight'
                            ? Colors.blue
                            : status == 'Normal weight'
                                ? Colors.green
                                : status == 'Pre-Obesity'
                                    ? Colors.yellow.shade700
                                    : status == 'Obesity class 1'
                                        ? Colors.orange
                                        : status == 'Obesity class 2'
                                            ? Colors.deepOrangeAccent
                                            : status == 'Obesity class 3'
                                                ? Colors.red
                                                : null),
                  ),
                  const Text(
                    'ИМТ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(50),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                  offset: Offset(
                    5.0,
                    5.0,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Nutritional Status',
            style: TextStyle(color: Colors.black54, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 25,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(15)),
                    color: Colors.blue,
                  ),
                  child: const Center(
                      child: Text('Underweight',
                          style: TextStyle(fontSize: 8, color: Colors.white))),
                ),
              ),
              Expanded(
                child: Container(
                  height: 25,
                  color: Colors.green,
                  child: const Center(
                      child: Text('Normal \nweight',
                          style: TextStyle(fontSize: 8, color: Colors.white))),
                ),
              ),
              Expanded(
                child: Container(
                  height: 25,
                  color: Colors.yellow.shade700,
                  child: const Center(
                      child: Text('Pre-Obesity',
                          style: TextStyle(fontSize: 8, color: Colors.white))),
                ),
              ),
              Expanded(
                child: Container(
                  height: 25,
                  color: Colors.orange,
                  child: const Center(
                      child: Text('Obesity \nclass 1',
                          style: TextStyle(fontSize: 8, color: Colors.white))),
                ),
              ),
              Expanded(
                child: Container(
                  height: 25,
                  color: Colors.deepOrangeAccent,
                  child: const Center(
                      child: Text('Obesity \nclass 2',
                          style: TextStyle(fontSize: 8, color: Colors.white))),
                ),
              ),
              Expanded(
                child: Container(
                  height: 25,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(15)),
                    color: Colors.red,
                  ),
                  child: const Center(
                      child: Text('Obesity \nclass 3',
                          style: TextStyle(fontSize: 8, color: Colors.white))),
                ),
              ),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('00',
                  style: TextStyle(
                    color: Colors.transparent,
                  )),
              Text('18.5'),
              Text('25.0'),
              Text('30.0'),
              Text('35.0'),
              Text('40.0'),
              Text('00',
                  style: TextStyle(
                    color: Colors.transparent,
                  )),
            ],
          ),
        ],
      ),
    ),
  );
}
