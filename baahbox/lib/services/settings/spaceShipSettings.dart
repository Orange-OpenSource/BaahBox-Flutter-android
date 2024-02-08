import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/appController.dart';
import 'package:baahbox/routes/routes.dart';

class SpaceShipSettingsPage extends StatefulWidget {
  const SpaceShipSettingsPage({Key? key}) : super(key: key);

  @override
  _ValidationsState createState() => _ValidationsState();
}

class _ValidationsState extends State<SpaceShipSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    final pwdController = TextEditingController();

    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Space Ship Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  hintText: ' name...'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: pwdController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: ' phone',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: ' email...,',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    GetUtils.isLengthGreaterThan(nameController.text, 6)
                        ? print('Name is valid')
                        : print('Name is invalid!!!');

                    GetUtils.isPhoneNumber(pwdController.text)
                        ? print('Phone Number')
                        : print('Not a Phone Number');

                    GetUtils.isEmail(emailController.text)
                        ? print('Email is valid')
                        : print('Email is invalid!!!');
                  });
                },
                child: const Text("Validate"))
          ],
        ),
      ),
    );
  }
}
