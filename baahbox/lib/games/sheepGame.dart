
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:baahbox/model/sensorInput.dart';
import 'package:baahbox/controllers/appController.dart';
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
        ]
        )
    )
    ));
  }
}
