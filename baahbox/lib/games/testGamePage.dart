/*
 * Baah Box
 * Copyright (c) 2024. Orange SA
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 */

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
                  onPressed: () => Get.toNamed(BBRoute.welcome.path)
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


