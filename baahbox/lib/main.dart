import 'package:flutter/material.dart';
import 'package:baahbox/routes/routes.dart';
import 'package:get/get.dart';

void main() {

  return runApp(
     GetMaterialApp(
        title: 'Baah Box Games!',
      //  home: const BleConnectionPage(),
        initialRoute: BBRoutes.welcome,
      getPages: BBRoutes.routes
     ),
  );
}
