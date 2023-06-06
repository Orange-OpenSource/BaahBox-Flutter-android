import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:baahbox/model/sensorInput.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:baahbox/routes/routes.dart';

class TestGamePage extends StatelessWidget {
  @override
  Widget build(context) {
    final Controller c = Get.find();
    return Obx(() =>
        Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
              centerTitle: true,
              title: Text("Test Page"),
              leading: IconButton(
                  icon: Icon( Icons.arrow_back,color: Colors.lightBlueAccent,),
                  onPressed: () => Get.toNamed(BBRoutes.welcome)
              ),
            ),
            body: Container(alignment: Alignment.center,
              child:
                Column(mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(c.musclesInput.describe()),
                      sensorTest(),
                    ]
                )
            ),
          floatingActionButton: FloatingActionButton(
          onPressed: () => Get.back(),
          tooltip: 'Increment',
          child: const Icon(Icons.arrow_back),
        ), //
            )
        );
  }
}

class sensorTest extends StatelessWidget {
  const sensorTest ({super.key});
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


