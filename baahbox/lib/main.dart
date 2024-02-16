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
