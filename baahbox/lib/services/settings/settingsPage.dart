/*
 * Baah Box
 * Copyright (c) 2024. Orange SA
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 */

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
          title: Text("Réglages"),
        ),
        body: ListView(padding: const EdgeInsets.all(0), children: [
          Card(
            shape: ContinuousRectangleBorder(),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Paramètres',
                    style: Theme.of(context).textTheme.titleMedium)),
          ),
          ListTile(
              trailing: Icon(Icons.arrow_forward_outlined),
              dense: false,
              enabled: true,
              onTap: () => Get.toNamed(BBRoute.connection.path),
              title: Text('Connexion',
                  style: Theme.of(context).textTheme.bodyLarge)),
          const SizedBox(
            height: 15,
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_outlined),
            dense: false,
            enabled: true,
            onTap: () => Get.toNamed(BBRoute.generalSettings.path),
            title:
                Text('Général', style: Theme.of(context).textTheme.bodyLarge),
          ),
          const SizedBox(
            height: 15,
          ),
          Card(
            shape: ContinuousRectangleBorder(),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Gestion des jeux',
                    style: Theme.of(context).textTheme.titleMedium)),
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_outlined),
            dense: false,
            enabled: true,
            onTap: () => Get.toNamed(BBRoute.sheepSettings.path),
            title: Text('Saute mouton',
                style: Theme.of(context).textTheme.bodyLarge),
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            height: 0,
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_outlined),
            dense: false,
            enabled: true,
            onTap: () => Get.toNamed(BBRoute.spaceShipSettings.path),
            title: Text('Bataille de l\'espace',
                style: Theme.of(context).textTheme.bodyLarge),
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            height: 0,
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_outlined),
            dense: false,
            enabled: true,
            onTap: () => Get.toNamed(BBRoute.toadSettings.path),
            title: Text('Gobe les mouches',
                style: Theme.of(context).textTheme.bodyLarge),
          ),
          const Divider(
            height: 0,
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_outlined),
            dense: false,
            enabled: true,
            onTap: () => Get.toNamed(BBRoute.mazeSettings.path),
            title: Text('Labyrinthe',
                style: Theme.of(context).textTheme.bodyLarge),
          ),
          Card(
            shape: ContinuousRectangleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                '',
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_outlined),
            dense: false,
            enabled: true,
            onTap: () => Get.toNamed(BBRoute.termsAndConditions.path),
            title:
                Text('A propos', style: Theme.of(context).textTheme.bodyLarge),
          ),
        ]));
  }
}
