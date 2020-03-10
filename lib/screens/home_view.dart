import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:safejourney/constants/routing_constants.dart';
// import 'package:safejourney/widgets/network_sensitive.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safejourney/bloc/bloc.dart';
import 'package:safejourney/constants/routing_constants.dart';
import 'package:safejourney/themes/styles.dart';
import 'package:safejourney/utilities/places.dart';
import 'package:safejourney/widgets/deal_of_day_widget.dart';
import 'package:safejourney/widgets/join_us_widget.dart';
import 'package:safejourney/widgets/top_places_widget.dart';

class HomeView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
        key: _scaffoldKey,

        // drawer: Drawer(

        //   child: _buildSideDrawer(),
        // ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "safejourney.ng",
            style: smallBoldTextStyle,
          ),
          elevation: 0.0,
          centerTitle: false,
          leading: InkWell(
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            onTap: () {
              // _scaffoldKey.currentState.openDrawer();
              // authenticationBloc.dispatch(LoggedOut());
            },
          ),
          actions: <Widget>[
            Theme(
              data: Theme.of(context).copyWith(
                cardColor: Colors.white,
              ),
              child: PopupMenuButton<int>(
                itemBuilder: (context) => [
                  // PopupMenuItem(
                  //   value: 1,
                  //   child: Text("Booking History"),
                  // ),
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      "Booking Status",
                      style: TextStyle(color: Colors.blueGrey[800]),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text(
                      "Sign out",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 1:
                      Navigator.of(context).pushNamed(BookingStatus);
                      break;
                    case 2:
                      authenticationBloc.dispatch(LoggedOut());
                      break;
                    case 3:
                      break;
                    default:
                  }
                },
              ),
            )
            // IconButton(icon: Icon(
            //   Icons.settings,
            //   color: Colors.blueGrey,
            // ),
            // onPressed: (){

            // },
            // ),
            //  IconButton(icon: Icon(
            //   FontAwesome.info,
            //   color: Colors.black,
            // ),
            // onPressed: (){

            // },
            // ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.black,
        //   onPressed: () {
        //     Navigator.of(context).pushNamed(TripResultScreenRoute);
        //   },
        //   child: Icon(
        //     Icons.search,
        //   ),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(16.0)),
        //   ),
        // ),
        // bottomNavigationBar: CurvedNavigationBar(
        //   buttonBackgroundColor: Colors.transparent,
        //   backgroundColor: Color(0XFFF7F7FC),
        //   items: <Widget>[
        //     Icon(
        //       Icons.call_split,
        //       size: 30,
        //     ),
        //     Icon(
        //       Feather.list,
        //       size: 30,
        //     ),
        //     Icon(
        //       Feather.user,
        //       size: 30,
        //     ),
        //   ],
        //   onTap: (index) {
        //     //Handle button tap
        //   },
        // ),
        body: Container(
          // color: Colors.black,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildSearchtop(context),
                DealDayWidget(),
                TopPlacesWidget(),
                JoinUsWidget(),
                // FlightListingBottomPart(),
              ],
            ),
          ),
        ));
  }
}

Widget _buildSideDrawer() {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text(''),
          decoration: BoxDecoration(
            color: Colors.blueGrey[600],
          ),
        ),
        ListTile(
          title: Text('Booking History'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          title: Text('Logout'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
      ],
    ),
  );
}

class SearchTripTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // ClipPath(
        //   clipper: CustomShapeClipper(),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(colors: [firstColor, secondColor]),
        //     ),
        //     height: 160.0,
        //   ),
        // ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero)),
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              elevation: 8.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextField(
                            onChanged: (text) {},
                            decoration: InputDecoration(
                                hasFloatingPlaceholder: false,
                                prefixIcon: Icon(Icons.arrow_upward),
                                border: InputBorder.none,
                                labelText: 'Choose Departure'),
                          ),
                          // Divider(
                          //   color: Colors.grey,
                          //   height: 20.0,
                          // ),
                          TextField(
                            onChanged: (text) {},
                            decoration: InputDecoration(
                                filled: true,
                                hasFloatingPlaceholder: false,
                                prefixIcon: Icon(Icons.arrow_downward),
                                border: InputBorder.none,
                                labelText: 'Choose Arrival'),
                          ),
                          SizedBox(
                            height: 56,
                            width: double.infinity,
                            child: FlatButton(
                              child: Row(
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(Icons.arrow_forward)),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Aug 12, 2019",
                                        textAlign: TextAlign.start,
                                      ))
                                ],
                              ),
                              color: Colors.black,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(StateSearchRoute);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    // Spacer(),
                    // Expanded(
                    //   flex: 1,
                    //   child: Icon(
                    //     Icons.import_export,
                    //     color: Colors.black,
                    //     size: 32.0,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

//
Widget _buildSearchtop(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      //     Padding(
      //     padding: EdgeInsets.all(20),
      //   child: Container(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: <Widget>[
      //       Text("Hello, Jane.", style: TextStyle(fontSize: 30.0, color: Colors.black),),
      //         Text("Looks like feel good.", style: TextStyle(color: Colors.black),),
      //         Text("You have 3 tasks to do today.", style: TextStyle(color: Colors.black,),),
      //       ],
      //     ),
      //   ),
      // ),
      Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "Hi, where would you \nlike to go?",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 24,
            color: Colors.blueGrey[800],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(StateSearchRoute);
            },
            child: Container(
              child: TextField(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  Navigator.of(context).pushNamed(StateSearchRoute);
                },
                enableInteractiveSelection: false,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.blueGrey[300],
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "E.g: Lagos, Delta, Abuja",
                  prefixIcon: Icon(
                    Icons.arrow_upward,
                    color: Colors.blueGrey[300],
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.blueGrey[300],
                  ),
                ),
                maxLines: 1,
                // controller: _searchControl,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
