import 'package:flutter/material.dart';
import 'package:rahbaran/common/plaque_id_direction.dart';

class Plaque extends StatelessWidget {
  final String plaqueSerial;
  final String plaqueId;

  Plaque(serial,id):plaqueSerial=serial==null?'--':serial.toString(),plaqueId=id==null?'':id.toString();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 45,
        width: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.asset('assets/images/plate.png').image,
            fit: BoxFit.fill,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 5, right: 12),
              child: Text(
                plaqueSerial,
                style: Theme.of(context).textTheme.body2,
              ),
            ),
            Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    PlaqueIdDirection.changePlaqueIdDirection(plaqueId),
                    style: Theme.of(context).textTheme.body2,
                  ),
                ))
          ],
        ));
  }
}
