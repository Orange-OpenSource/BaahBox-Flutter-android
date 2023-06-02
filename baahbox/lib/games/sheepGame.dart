
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:baahbox/util/sensorInput.dart';
import 'package:baahbox/appController.dart';
import 'package:get/get.dart';

class SheepGame extends StatelessWidget {
  @override
  Widget build(context) {
    final Controller c = Get.find();
    return Obx(() =>
        Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey, // foreground
            ),
            onPressed: () => Get.back(),
            child: const Text('Sheep ! Back to earth !'),
          ),
          Text(c.musclesInput.describe()),
                  Star()
        ]
        )
    )
    ));
  }
}

class Star extends StatelessWidget {
  const Star ({super.key});


  @override
  Widget build(BuildContext context) {
    final Controller controller = Get.find();
    return Obx(() =>
        Container(
          width: 150,
          height: (controller.musclesInput.muscle1).toDouble() / 5,
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(),
          ),

          child: Text(controller.musclesInput.describe())
    )
    );
    }
}
