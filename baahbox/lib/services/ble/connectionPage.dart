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

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:baahbox/controllers/appController.dart';

import 'BleController.dart';
import 'bleDevicesView.Dart';
import 'bleMonitorView.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({Key? key}) : super(key: key);
  final String title = "BaahBle";

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final Controller appController = Get.find();
  final BleController bleController = Get.find();



  void initState() {
    super.initState();
  }

  Future<bool> _onBackPressed() {
    bleController.stopScanDevices();
    Navigator.of(context).pop(true);
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(title: Text("Connexion")),
          body: SafeArea(
            child: Expanded(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  BleMonitorView(),
                  Obx(() {
                    if (bleController.availableDevices.isBlank == true) {
                      return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text("Aucune BaahBox trouvée.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold))));
                    } else {
                      return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text("Sélectionnez votre Baah Box: ",
                                  style:
                                      Theme.of(context).textTheme.bodyLarge)));
                    }
                  }),
                  SizedBox(
                    height: 15,
                  ),
                  BleDevicesView(),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: const Text("Données reçues:",
                          textAlign: TextAlign.left)),
                  Container(
                      margin: const EdgeInsets.all(5.0),
                      width: 1400,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.blue, width: 2)),
                      height: 90,
                      child: Obx(() {
                        if (bleController.adaptaterState.value ==
                            BleAdapterState.enable) {
                          return Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                  "${appController.analogInputs.describe()}\n${appController.digitalInputs.describe()}"));
                        } else {
                          return const Text("");
                        }
                      })),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            )),
          )));
}
