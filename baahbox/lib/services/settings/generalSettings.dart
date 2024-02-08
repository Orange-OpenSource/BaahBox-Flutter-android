import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:baahbox/routes/routes.dart';
import 'package:baahbox/services/settings/settingsController.dart';

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
            child: Text(
              'Sign In',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  //      TextFormField(

                  //            controller: controller.emailController,
                  //           decoration: InputDecoration(
                  //              labelText: 'Enter email',
                  //              border: const OutlineInputBorder(),
                  //              isDense: true,
                  //              hintText:  'Enter email',
                  //            ),
                  //          ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  TextFormField(

                    controller: controller.passwordController,
                    decoration: InputDecoration(
                      labelText: 'Enter password',
                      border: const OutlineInputBorder(),
                      isDense: true,
                        hintText:  'Enter password',
                    ),
                  ),
                  SliderExample(),
                  Slider(
                      value: _currentSliderValue,
                      max: 10,
                      divisions: 10,
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        {
                          _currentSliderValue = value;
                        }
                      }),
                  const SizedBox(
                    height: 24,
                  ),
                  SensorChoice(),
                  Text("Demo mode"),
                  SwitchExample(),
                  const SizedBox(
                    height: 24,
                  ),
                  // Obx(() =>
                  TextButton(
                      //label: 'Sign in',
                      onPressed: controller.onLogin,
                      // isLoading: controller.status.isLoading,
                      child: const Text("sign in"))
                  //  )
                ],
              ),
            ),
          ),
          IconButton(
              icon: Image.asset('assets/images/Dashboard/settings_icon@2x.png',
                  color: mainColor),
              onPressed: () => Get.toNamed('/settings')),
        ],
      ),
    );
  }
}

class SensorChoice extends StatefulWidget {
  const SensorChoice({super.key});
  @override
  State<SensorChoice> createState() => _SensorChoiceState();
}

class _SensorChoiceState extends State<SensorChoice> {
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
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.red,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
    );
  }
}
