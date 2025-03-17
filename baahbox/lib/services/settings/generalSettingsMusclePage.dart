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
          ListTile(
              title: Text("Muscle1"),
              trailing: Obx(() => Switch(
                    value: controller.genericSettings["isSensor1On"],
                    activeColor: Colors.red,
                    onChanged: (bool val) {
                      controller.setMuscle1To(val);
                    },
                  ))),
          const SizedBox(
            height: 5,
          ),
          ListTile(
              title: Text("Muscle2"),
              trailing: Obx(() => Switch(
                    value: controller.genericSettings["isSensor2On"],
                    activeColor: Colors.red,
                    onChanged: (bool val) {
                      controller.setMuscle2To(val);
                    },
                  )))
        ]));
  }
}
