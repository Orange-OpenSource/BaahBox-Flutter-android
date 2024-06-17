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
import 'package:baahbox/routes/routes.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

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
          title: Text("A propos"),
        ),
        backgroundColor: Colors.white,
        body:ListView(
            padding: const EdgeInsets.all(0),
            children:
            [
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
                => Get.toNamed(BBRoute.cgu.path),
                title: Text("Conditions d'utilisation"),
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
                => Get.toNamed(BBRoute.legals.path),
                title: Text('Mentions Légales'),
              ),
            ]));
  }
}
