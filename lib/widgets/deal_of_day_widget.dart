import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DealDayWidget extends StatefulWidget {
  @override
  _DealDayWidgetState createState() => _DealDayWidgetState();
}

class _DealDayWidgetState extends State<DealDayWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Text(
              "Promo Yakata",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 24,
                color: Colors.blueGrey[800],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 0,
              child: new Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.1), BlendMode.darken),
                      image: ExactAssetImage('images/deal.jpg'),
                      fit: BoxFit.cover),
                ),
                // color: Color(0xffF4F2EF),
                width: double.infinity,
                height: 400,
                padding: new EdgeInsets.all(20.0),
                child: Center(
                  child: new Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Deal of the day",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                       SizedBox(
                        height: 10,
                      ),
                      Text(
                        "25% percent discount for the first\n5 people to book between the\nfirst 5 days of every month daily.",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 44,
                        child: OutlineButton(
                          borderSide: BorderSide(color: Colors.white),
                          onPressed: () async{
                            const url = "https://www.safejourney.ng/";
                            if (await canLaunch(url)) {
                              await launch(url);
                            }
                            // Navigator.of(context).pushNamed(HomeViewRoute);

                            // Navigator.of(context).pushReplacementNamed(HomeViewRoute,
                            //     arguments: widget._userRepository);
                          },
                          child: Text(
                            'Learn more',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
