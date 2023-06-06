import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/appController.dart';
import 'package:baahbox/routes/routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: 25),
          centerTitle: true,
          title: Text("Settings"),
          leading: IconButton(
              icon: Icon( Icons.arrow_back,color: Colors.lightBlueAccent,),
              onPressed: () => Get.toNamed(BBRoutes.welcome)
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              ElevatedButton(
                  onPressed: () => Get.toNamed(BBRoutes.connection),
                  child: Text('Connexion settings'))
            ])));
  }
}
