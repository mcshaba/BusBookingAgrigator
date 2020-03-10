import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safejourney/themes/styles.dart';

class LocationWidget extends StatelessWidget {
  final String stationName, cityName, time;
  final String destinationName, destCityName, destTime;

  LocationWidget({
    @required this.stationName,
    @required this.cityName,
    @required this.time,
    @required this.destinationName,
    @required this.destCityName,
    @required this.destTime,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(stationName.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: bigTextStyle),
                    SizedBox(height: 2.0),
                    Text(
                      cityName,
                      style: smallTextStyle,
                    ),
                    SizedBox(height: 2.0),
                  ],
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  margin: EdgeInsets.only(right: 10, left: 10),
                  child: Icon(
                    // Entypo.shuffle,
                    Icons.arrow_forward,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(destinationName.toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: bigTextStyle),
                    SizedBox(height: 2.0),
                    Text(
                      destCityName,
                      style: smallTextStyle,
                    ),
                    SizedBox(height: 2.0),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(time, style: mediumTextStyle),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(destTime, style: mediumTextStyle),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class LocationEndWidget extends StatelessWidget {
  final String stationName, cityName, time;

  LocationEndWidget(
      {@required this.stationName,
      @required this.cityName,
      @required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(stationName.toUpperCase(),
            maxLines: 2, overflow: TextOverflow.ellipsis, style: bigTextStyle),
        SizedBox(height: 2.0),
        Text(
          cityName,
          style: smallTextStyle,
        ),
        SizedBox(height: 2.0),
        Text(time, style: mediumTextStyle),
      ],
    );
  }
}
