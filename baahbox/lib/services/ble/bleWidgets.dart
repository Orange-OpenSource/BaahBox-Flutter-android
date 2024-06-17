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
//import 'package:flutter_blue/flutter_blue.dart';

// class ScanResultTile extends StatelessWidget {
//  // const ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);
//   const ScanResultTile({required Key key, required this.onTap}) : super(key: key);
//
//  // final ScanResult result;
//   final VoidCallback onTap;
//
//   Widget _buildTitle(BuildContext context) {
//
//     //if (result.device.name.length > 0) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           const Text( "baahbox",
//             //result.device.name,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const Text("id",
//            // result.device.id.toString(),
//           //  style: Theme.of(context).textTheme.caption,
//           )
//         ],
//       );
//     }
//     //else {
//      // return  Text(result.device.id.toString());
//     //}
//   //}
//
//   String getNiceHexArray(List<int> bytes) {
//     return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
//         .toUpperCase();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: _buildTitle(context),
//       leading: const Text("rssi"), //Text(result.rssi.toString()),
//       trailing: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
//             padding: const EdgeInsets.all(12.0),
//             primary: Colors.white,
//           ),
//           onPressed: null,//(result.advertisementData.connectable) ? onTap : null,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child:
//             Text("CONNECT", style: TextStyle(color: Colors.white)),
//           )),
//       children: <Widget>[],
//     );
//   }
// }