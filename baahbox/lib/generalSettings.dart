import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/appController.dart';
import 'package:baahbox/routes/routes.dart';
import './settingsController.dart';

class GeneralSettingsPage extends GetView<SettingsController> {
  const GeneralSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  TextFormField(

                    controller: controller.passwordController,
                    decoration: InputDecoration(
                      labelText: 'Enter email',
                      border: const OutlineInputBorder(),
                      isDense: true,
                      hintText:  'Enter email',
                    ),
                  ),
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
                  const SizedBox(
                    height: 24,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Obx(() {
                    return TextButton(
                      //label: 'Sign in',
                      onPressed: controller.onLogin,
                     // isLoading: controller.status.isLoading,
                      child: const Text("sign in")
                    );
                  })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
