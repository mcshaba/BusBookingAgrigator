import 'package:flutter/material.dart';
import 'package:safejourney/constants/routing_constants.dart';
import 'package:safejourney/repository/user_repository.dart';

class JoinUsWidget extends StatefulWidget {
  @override
  _JoinUsWidgetState createState() => _JoinUsWidgetState();
}

class _JoinUsWidgetState extends State<JoinUsWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(LoginViewRoute, arguments: UserRepository());
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Join us for great deals",
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
                  color: Color(0xffF4F2EF),
                  width: double.infinity,
                  height: 440,
                  padding: new EdgeInsets.all(20.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: new Image.asset(
                          'images/screen1.5.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      // Container(
                      //   width: double.infinity,
                      //   child: Image.asset(
                      //     'images/bus.png',
                      //   ),
                      // ),
                      Text(
                        "Enjoy great deals & offers from the comfort of your home.",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Join us now',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey[900],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
