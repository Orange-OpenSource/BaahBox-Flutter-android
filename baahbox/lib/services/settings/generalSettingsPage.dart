import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:baahbox/routes/routes.dart';
import 'package:baahbox/services/settings/settingsController.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

class GeneralSettingsPage extends GetView<SettingsController> {
  // final SettingsController controller = Get.find();
  final mainColor = BBColor.pinky.color;
  double _currentSliderValue = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General Settings'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 32, top: 8),
            // child: Text(
            //   'Sign In',
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ),
          Card(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mode',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Sélectionnez le mode d\'utilisation',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ]))),
          const SizedBox(
            height: 15,
          ),
          const SwitchExample(title: "Mode démo"),
          // SwitchListTile(
          //   title: const Text('Floating Action Button'),
          //   value: true,
          //   onChanged: (bool val){}, //controller.doTheRightThing(v),
          // ),
          const SizedBox(
            height: 24,
          ),
          Card(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Type de capteur',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Précisez le type de capteur utilisé',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ]))),
          const SizedBox(
            height: 12,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
             child: const Text(
            'Capteur utilisé',
            style: TextStyle(
              fontSize: 16,
            ),
          )),
          Align(
              alignment: Alignment.center, child: SensorSegmentedSegment()),
          const SizedBox(
            height: 24,
          ),
          const SizedBox(
            height: 12,
          ),
          Card(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Muscle de travail',
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
          SwitchExample(title: "Muscle 1"),
          const SizedBox(
            height: 5,
          ),
          SwitchExample(title: "Muscle 2"),
          Card(
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
    Align(
    alignment: Alignment.center, child: SensitivitySegmentedSegment()),
          const SizedBox(
            height: 24,
          ),
          // Card(
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         TextFormField(
          //           controller: controller.passwordController,
          //           decoration: InputDecoration(
          //             labelText: 'Enter password',
          //             border: const OutlineInputBorder(),
          //             isDense: true,
          //             hintText: 'Enter password',
          //           ),
          //         ),
          //         SliderExample(),
          //
          //         RadioSensorChoice(),
          //
          //         const SizedBox(
          //           height: 24,
          //         ),
          //         // Obx(() =>
          //         TextButton(
          //             //label: 'Sign in',
          //             onPressed: controller.onLogin,
          //             // isLoading: controller.status.isLoading,
          //             child: const Text("sign in"))
          //         //  )
          //       ],
          //     ),
          //   ),
          // ),
          // const Padding(
          //   padding: EdgeInsets.only(left: 32, top: 8),
          //   child: Text(
          //     'Sign In',
          //     style: TextStyle(
          //       fontSize: 18,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          // IconButton(
          //     icon: Image.asset('assets/images/Dashboard/settings_icon@2x.png',
          //         color: mainColor),
          //     onPressed: () => Get.toNamed('/settings')),
        ],
      ),
    );
  }
}

class SensitivitySegmentedSegment extends StatefulWidget {
  const SensitivitySegmentedSegment({super.key});

  @override
  State<SensitivitySegmentedSegment> createState() =>
      _SensitivitySegmentedSegmentState();
}

class _SensitivitySegmentedSegmentState
    extends State<SensitivitySegmentedSegment> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return CustomSlidingSegmentedControl<int>(
      initialValue: 2,
      children: {
        1: Text('Faible'),
        2: Text('Moyenne'),
        3: Text('Elevée'),
      },
      decoration: BoxDecoration(
        color: CupertinoColors.lightBackgroundGray,
        borderRadius: BorderRadius.circular(8),
      ),
      thumbDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.3),
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: Offset(
              0.0,
              2.0,
            ),
          ),
        ],
      ),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInToLinear,
      onValueChanged: (v) {
        print(v);
        //controller.doTheRightThing(v);
      },
    );
  }
}

class SensorSegmentedSegment extends StatefulWidget {
  const SensorSegmentedSegment({super.key});

  @override
  State<SensorSegmentedSegment> createState() => _SensorSegmentedSegmentState();
}

class _SensorSegmentedSegmentState extends State<SensorSegmentedSegment> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return CustomSlidingSegmentedControl<int>(
      initialValue: 2,
      children: {
        1: Text('Muscle'),
        2: Text('Joystick'),
        3: Text('Button'),
      },
      decoration: BoxDecoration(
        color: CupertinoColors.lightBackgroundGray,
        borderRadius: BorderRadius.circular(8),
      ),
      thumbDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.3),
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: Offset(
              0.0,
              2.0,
            ),
          ),
        ],
      ),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInToLinear,
      onValueChanged: (v) {
        print(v);
        // controller.doTheRightThing(v);
      },
    );
  }
}

class RadioSensorChoice extends StatefulWidget {
  const RadioSensorChoice({super.key});
  @override
  State<RadioSensorChoice> createState() => _RadioSensorChoiceState();
}

class _RadioSensorChoiceState extends State<RadioSensorChoice> {
  final SettingsController controller = Get.find();
  int _value = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text("button"),
          leading: Radio(
            groupValue: _value,
            value: 1,
            onChanged: (int? value) {
              setState(() {
                _value = value ?? 0;
                controller.doTheRightThing(value);
              });
            },
          ),
        ),
        ListTile(
          title: Text("joystick"),
          leading: Radio(
            groupValue: _value,
            value: 2,
            onChanged: (int? value) {
              setState(() {
                _value = value ?? 0;
                controller.doTheRightThing(value);
              });
            },
          ),
        ),
        ListTile(
          title: Text("muscle"),
          leading: Radio(
            groupValue: _value,
            value: 3,
            onChanged: (int? value) {
              setState(() {
                _value = value ?? 0;
                controller.doTheRightThing(value);
              });
            },
          ),
        ),
      ],
    );
  }
}

class SliderExample extends StatefulWidget {
  const SliderExample({super.key});

  @override
  State<SliderExample> createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      max: 100,
      divisions: 5,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key, required this.title});
  final String title;

  @override
  State<SwitchExample> createState() => _SwitchExampleState(title: title);
}

class _SwitchExampleState extends State<SwitchExample> {
  _SwitchExampleState({required this.title});
  bool light = true;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title),
        trailing: Switch(
          // This bool value toggles the switch.
          value: light,
          activeColor: Colors.red,
          onChanged: (bool value) {
            // This is called when the user toggles the switch.
            setState(() {
              light = value;
            });
          },
        ));
  }
}
