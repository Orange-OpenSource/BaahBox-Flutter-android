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
import 'package:baahbox/routes/routes.dart';
import 'package:get/get.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:baahbox/services/settings/settingsController.dart';
import 'package:get_storage/get_storage.dart';
import 'package:baahbox/services/ble/getXble/getx_ble.dart';

void main() async {
  await GetStorage.init();
  final Controller c = Get.put(Controller());
  final GetxBle bleController = Get.put(GetxBle());
  final SettingsController settingsController = Get.put(SettingsController());

  return runApp(

     GetMaterialApp(
        title: 'Baah Box Games!',
      //  home: const BleConnectionPage(),
        initialRoute: BBRoute.welcome.path,
      getPages: BBRoutes.routes,
       debugShowCheckedModeBanner: false,
     ),
  );
}
