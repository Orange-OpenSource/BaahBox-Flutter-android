import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:baahbox/routes/routes.dart';
import 'package:baahbox/services/settings/settingsController.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

class SheepSettingsPage extends GetView<SettingsController> {
  final mainColor = BBColor.pinky.color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réglages du saute mouton'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 32, top: 8),
          ),
          Card(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nombre de barrières',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ]))),
          const SizedBox(
            height: 15,
          ),
          GateNumberSlider(),
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
                          'Vitesse des barrières',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]))),
          const SizedBox(
            height: 12,
          ),
          Align(
              alignment: Alignment.center, child: GateSpeedSegmentedSegment()),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}

class GateSpeedSegmentedSegment extends StatefulWidget {
  const GateSpeedSegmentedSegment({super.key});

  @override
  State<GateSpeedSegmentedSegment> createState() =>
      _GateSpeedSegmentedSegmentState();
}

class _GateSpeedSegmentedSegmentState extends State<GateSpeedSegmentedSegment> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final  speed = (controller.sheepParams["gateVelocity"]) as ObjectVelocity;
    int displayValue = speed.value;

    return CustomSlidingSegmentedControl<int>(
      initialValue: displayValue,
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
      onValueChanged: (int v) {
        displayValue = v;
        controller.setGateSpeedTo(v);
      },
    );
  }
}

class GateNumberSlider extends StatefulWidget {
  const GateNumberSlider({super.key});

  @override
  State<GateNumberSlider> createState() => _GateNumberSliderState();
}

class _GateNumberSliderState extends State<GateNumberSlider> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final int _nbG = (controller.sheepParams["numberOfGates"]);
    double _value = _nbG.toDouble();
    return Slider(
      value: _value,
      min: 1.0,
      max: 10.0,
      divisions: 10,
      label: _value.round().toString(),
      onChanged: (double value) {
        setState(() {
          _value = value;
          controller.setGateNumberTo(value.toInt());
        });
      },
    );
  }
}
