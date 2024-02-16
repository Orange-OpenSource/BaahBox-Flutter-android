import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:baahbox/controllers/appController.dart';
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
          title: Text("Réglages"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Get.toNamed(BBRoute.welcome.path)
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Card(
                    shape: ContinuousRectangleBorder(),
                    child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                                const Text('',),),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ListTile(
                    trailing: Icon(Icons.arrow_forward_outlined),
                    dense: false,
                    enabled: true,
                    onTap: ()
                      => Get.toNamed(BBRoute.connection.path),
                    title: Text('Connexion'),
                  ),
                  Card(
                    shape: ContinuousRectangleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                      const Text('',),),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ListTile(
                    trailing: Icon(Icons.arrow_forward_outlined),
                    dense: false,
                    enabled: true,
                    onTap: ()
                    => Get.toNamed(BBRoute.generalSettings.path),
                    title: Text('Général '),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Card(
                    shape: ContinuousRectangleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                      const Text('Gestion des jeux', style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),),
                  ),

                  ListTile(
                    trailing: Icon(Icons.arrow_forward_outlined),
                    dense: false,
                    enabled: true,
                    onTap: ()
                    => Get.toNamed(BBRoute.sheepSettings.path),
                    title: Text('Saute mouton'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(height: 0,),
                  ListTile(
                    trailing: Icon(Icons.arrow_forward_outlined),
                    dense: false,
                    enabled: true,
                    onTap: ()
                    => Get.toNamed(BBRoute.spaceShipSettings.path),
                    title: Text('Bataille de l\'espace'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(height: 0,),
                  ListTile(
                    trailing: Icon(Icons.arrow_forward_outlined),
                    dense: false,
                    enabled: true,
                    onTap: ()
                    => Get.toNamed(BBRoute.toadSettings.path),
                    title: Text('Gobe les mouches'),
                  ),
            ])));
  }
}
