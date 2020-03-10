import 'package:flutter/material.dart';
import 'package:safejourney/themes/styles.dart';

class AirportDetailWidget extends StatelessWidget {
  final String transport, seats, price, actualPrice ;

  AirportDetailWidget({this.transport, this.seats, this.price, this.actualPrice});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        buildDetailColumn("transport", transport),
        Spacer(),
        // buildDetailColumn("capacity", seats),
        Spacer(),
        buildEndDetailColumn("₦ price", price, actualPrice),
      ],
    );
  }

  Widget buildDetailColumn(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      Text(label.toUpperCase(), style: smallTextStyle,),
      SizedBox(height: 4.0,),
      Text(value, style: smallBoldTextStyle,textAlign: TextAlign.center,),
    ],
  );

  Widget buildEndDetailColumn(String label, String value, String oldValue) => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      Text(label.toUpperCase(), style: smallTextStyle,),
      SizedBox(height: 4.0,),
      RichText(text: new TextSpan(
        children: <TextSpan> [
          new TextSpan(text: oldValue, style: new TextStyle(
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          )),

          new TextSpan(text: " " +value, style: smallBoldTextStyle,),
        ]
      ),),

     // Text(value, style: smallBoldTextStyle,textAlign: TextAlign.center,),
    ],
  );
}
