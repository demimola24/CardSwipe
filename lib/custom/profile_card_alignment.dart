import 'dart:math';

import 'package:flutter/material.dart';


class ProfileCardAlignment extends StatelessWidget {
  final String cardData;
  final int index;
  ProfileCardAlignment(this.cardData,this.index);

  List<Color> colors = [Colors.purple,Color(0xFF8D76EB),Colors.deepOrange,Colors.lightBlueAccent,Colors.black,Colors.yellow,Colors.green,Colors.red,Colors.lightGreen];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      color: colors[(index*10)%8],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Name',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700)),
          SizedBox(height: 20,),
          Text('$cardData',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 44.0,
                  fontWeight: FontWeight.w700)),

          Padding(padding: EdgeInsets.only(bottom: 8.0)),
        ],
      ),
    );
  }
}
