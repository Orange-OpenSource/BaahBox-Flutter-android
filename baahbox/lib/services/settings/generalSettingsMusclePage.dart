import 'package:baahbox/services/settings/settingsController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../constants/enums.dart';
import '../../controllers/appController.dart';

class MuscleSettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: ListView(children: [
          Card(
              shape: ContinuousRectangleBorder(),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Muscle utilisé',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Sélectionnez le ou les muscles à travailler',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ]))),
          const SizedBox(
            height: 12,
          ),
          Obx(() => SwitchListTile.adaptive(
              title: const Text("Muscle1"),
              value: controller.genericSettings["isSensor1On"],
              onChanged: (bool newValue) {
                controller.setMuscle1To(newValue);
              })),
          const SizedBox(
            height: 5,
          ),
          Obx(() => SwitchListTile.adaptive(
              title: const Text("Muscle2"),
              value: controller.genericSettings["isSensor2On"],
              onChanged: (bool newValue) {
                controller.setMuscle2To(newValue);
              })),
        ]));
  }
}
