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
        width: double.infinity,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
          Container(
              padding: EdgeInsets.all(20),
              child: Obx(() => SwitchListTile.adaptive(
                  title: const Text("Muscle1"),
                  value: controller.genericSettings["isSensor1On"],
                  onChanged: (bool newValue) {
                    controller.setMuscle1To(newValue);
                  }))),
          const SizedBox(
            height: 5,
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: Obx(() => SwitchListTile.adaptive(
                  title: const Text("Muscle2"),
                  value: controller.genericSettings["isSensor2On"],
                  onChanged: (bool newValue) {
                    controller.setMuscle2To(newValue);
                  }))),
              Card(
                  shape: ContinuousRectangleBorder(),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sensibilité',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'Paramétrez la sensibilité des capteurs',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ]))),
              const SizedBox(
                height: 8,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: const Text(
                    'Sensibilité',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
              SensitivitySelectionView()

            ]));
  }


}

class SensitivitySelectionView extends StatefulWidget {
  const SensitivitySelectionView({super.key});

  @override
  State<SensitivitySelectionView> createState() =>
      _SensitivitySelectionViewState();
}

class _SensitivitySelectionViewState extends State<SensitivitySelectionView> {
  final SettingsController controller = Get.find();
  late Sensitivity? _selection;
  void onSelectionChanged(Sensitivity? value) {
    setState(() {
      _selection = value;
      if (value != null) {
        controller.updateSensitivityTo(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _selection = Sensitivity.medium;
    return Column(
      children: <Widget>[
        RadioListTile.adaptive(
            title: const Text('Faible'),
            value: Sensitivity.low,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged),
        RadioListTile.adaptive(
            title: const Text('Moyenne'),
            value: Sensitivity.medium,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged),
        RadioListTile.adaptive(
            title: const Text('Elevée'),
            value: Sensitivity.high,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged),
      ],
    );
  }
}
