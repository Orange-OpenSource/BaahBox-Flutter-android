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

class ScanResultTile extends StatelessWidget {
 // const ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);
  const ScanResultTile({required Key key, required this.onTap}) : super(key: key);

 // final ScanResult result;
  final VoidCallback onTap;

  Widget _buildTitle(BuildContext context) {

    //if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text( "baahbox",
            //result.device.name,
            overflow: TextOverflow.ellipsis,
          ),
          const Text("id",
           // result.device.id.toString(),
          //  style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    }
    //else {
     // return  Text(result.device.id.toString());
    //}
  //}

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: _buildTitle(context),
      leading: const Text("rssi"), //Text(result.rssi.toString()),
      trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
            padding: const EdgeInsets.all(12.0),
            primary: Colors.white,
          ),
          onPressed: null,//(result.advertisementData.connectable) ? onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child:
            Text("CONNECT", style: TextStyle(color: Colors.white)),
          )),
      children: <Widget>[],
    );
  }
}

// class ServiceTile extends StatelessWidget {
//   final BluetoothService service;
//   final List<CharacteristicTile> characteristicTiles;
//
//   const ServiceTile({Key key, this.service, this.characteristicTiles})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     if (characteristicTiles.length > 0) {
//       return ExpansionTile(
//         title: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text('Service'),
//             Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
//                 style: Theme.of(context)
//                     .textTheme
//                     .body1
//                     .copyWith(color: Theme.of(context).textTheme.caption.color))
//           ],
//         ),
//         children: characteristicTiles,
//       );
//     } else {
//       return ListTile(
//         title: Text('Service'),
//         subtitle:
//             Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}'),
//       );
//     }
//   }
// }

// class CharacteristicTile extends StatelessWidget {
//   final BluetoothCharacteristic characteristic;
//   final List<DescriptorTile> descriptorTiles;
//   final VoidCallback onReadPressed;
//   final VoidCallback onWritePressed;
//   final VoidCallback onNotificationPressed;
//
//   const CharacteristicTile(
//       {Key key,
//       this.characteristic,
//       this.descriptorTiles,
//       this.onReadPressed,
//       this.onWritePressed,
//       this.onNotificationPressed})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<int>>(
//       stream: characteristic.value,
//       initialData: characteristic.lastValue,
//       builder: (c, snapshot) {
//         final value = snapshot.data;
//         return ExpansionTile(
//           title: ListTile(
//             title: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text('Characteristic'),
//                 Text(
//                     '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
//                     style: Theme.of(context).textTheme.body1.copyWith(
//                         color: Theme.of(context).textTheme.caption.color))
//               ],
//             ),
//             subtitle: Text(value.toString()),
//             contentPadding: EdgeInsets.all(0.0),
//           ),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               IconButton(
//                 icon: Icon(
//                   Icons.file_download,
//                   color: Theme.of(context).iconTheme.color.withOpacity(0.5),
//                 ),
//                 onPressed: onReadPressed,
//               ),
//               IconButton(
//                 icon: Icon(Icons.file_upload,
//                     color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
//                 onPressed: onWritePressed,
//               ),
//               IconButton(
//                 icon: Icon(
//                     characteristic.isNotifying
//                         ? Icons.sync_disabled
//                         : Icons.sync,
//                     color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
//                 onPressed: onNotificationPressed,
//               )
//             ],
//           ),
//           children: descriptorTiles,
//         );
//       },
//     );
//   }
// }

//  class DescriptorTile extends StatelessWidget {
//   final BluetoothDescriptor descriptor;
//   final VoidCallback onReadPressed;
//   final VoidCallback onWritePressed;
//
//   const DescriptorTile(
//       {Key key, this.descriptor, this.onReadPressed, this.onWritePressed})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text('Descriptor'),
//           Text('0x${descriptor.uuid.toString().toUpperCase().substring(4, 8)}',
//               style: Theme.of(context)
//                   .textTheme
//                   .body1
//                   .copyWith(color: Theme.of(context).textTheme.caption.color))
//         ],
//       ),
//       subtitle: StreamBuilder<List<int>>(
//         stream: descriptor.value,
//         initialData: descriptor.lastValue,
//         builder: (c, snapshot) => Text(snapshot.data.toString()),
//       ),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           IconButton(
//             icon: Icon(
//               Icons.file_download,
//               color: Theme.of(context).iconTheme.color.withOpacity(0.5),
//             ),
//             onPressed: onReadPressed,
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.file_upload,
//               color: Theme.of(context).iconTheme.color.withOpacity(0.5),
//             ),
//             onPressed: onWritePressed,
//           )
//         ],
//       ),
//     );
//   }
// }

// class AdapterStateTile extends StatelessWidget {
//   const AdapterStateTile({Key key, @required this.state}) : super(key: key);
//
//   final BluetoothState state;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.redAccent,
//       child: ListTile(
//         title: Text(
//           'Bluetooth adapter is ${state.toString().substring(15)}',
//         ),
//         trailing: Icon(
//           Icons.error,
//         ),
//       ),
//     );
//   }
// }
