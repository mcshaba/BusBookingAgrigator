import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safejourney/apis/safe_journey_api.dart';
import 'package:safejourney/bloc/top_destination/bloc/top_destination_bloc.dart';
import 'package:safejourney/bloc/top_destination/bloc/top_destination_event.dart';
import 'package:safejourney/bloc/top_destination/bloc/top_destination_state.dart';
import 'package:safejourney/constants/routing_constants.dart';
import 'package:safejourney/navigation/router_arguments.dart';
import 'package:safejourney/repository/state_repository.dart';
import 'package:safejourney/themes/styles.dart';

class TopPlacesWidget extends StatefulWidget {
  const TopPlacesWidget({
    Key key,
  }) : super(key: key);

  @override
  _TopPlacesWidgetState createState() => _TopPlacesWidgetState();
}

class _TopPlacesWidgetState extends State<TopPlacesWidget> {
  final topDestinationBloc =
      TopDestinationBloc(repository: StateRepository(api: SafeJourneyApi()));

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    topDestinationBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Text(
            "Top destinations to visit",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 24,
              color: Colors.blueGrey[900],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Top destinations to visit & get great deals",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey[800],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, left: 20),
          height: 400,
//            color: Colors.red,
          width: MediaQuery.of(context).size.width,
          child: BlocProvider(
            builder: (context) => topDestinationBloc..loadTopDestinations(),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: TopDestinationWidget(),
            ),
//              child: BlocListener<TopDestinationBloc, TopDestinationState>(
//                  listener: (context, state) {
//                if (state is InitialTopDestinationState) {
//                  return Center(
//                    child: Image(
//                      image: new AssetImage("images/loader2.gif"),
//                      height: 200,
//                    ),
//                  );
//                }
//                if (state is TopDestinationLoading) {
//                  return Center(
//                    child: Image(
//                      image: new AssetImage("images/loader2.gif"),
//                      height: 200,
//                    ),
//                  );
//                }
//                if (state is TopDestinationError) {
//                  return Center(
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      children: <Widget>[
//                        Image(
//                          image: new AssetImage("images/error.gif"),
//                          height: 200,
//                        ),
//                        Center(
//                          child: Padding(
//                            padding: EdgeInsets.all(10.0),
//                            child: Text(
//                              state.error.toString(),
//                              style: smallTextStyle,
//                              textAlign: TextAlign.center,
//                            ),
//                          ),
//                        )
//                      ],
//                    ),
//                  );
//                }
//                if (state is TopDestinationLoaded) {
//                  return ListView.builder(
//                    scrollDirection: Axis.horizontal,
//                    primary: false,
//                    itemCount: state.topDestination.length,
//                    itemBuilder: (BuildContext context, int index) {
//                      //Map place = places.reversed.toList()[index];
//                      return Padding(
//                        padding: const EdgeInsets.only(right: 20),
//                        child: InkWell(
//                          child: Container(
//                            height: 400,
//                            width: 250,
////                      color: Colors.green,
//                            child: Column(
//                              children: <Widget>[
//                                ClipRRect(
//                                    borderRadius: BorderRadius.circular(4),
//                                    child: CircleAvatar(
//                                      backgroundImage: NetworkImage(
//                                        "${state.topDestination[index].img}",
//                                      ),
//                                    )
////                                    Image.asset(
////                                      "${place["img"]}",
////                                      height: 250,
////                                      width: 250,
////                                      fit: BoxFit.cover,
////                                    ),
//                                    ),
//                                SizedBox(height: 7),
//                                Container(
//                                  alignment: Alignment.centerLeft,
//                                  child: Text(
//                                    "${state.topDestination[index].name}",
//                                    style: TextStyle(
//                                      fontWeight: FontWeight.bold,
//                                      fontSize: 16,
//                                    ),
//                                    maxLines: 2,
//                                    textAlign: TextAlign.left,
//                                  ),
//                                ),
//                                SizedBox(height: 3),
//                                Container(
//                                  alignment: Alignment.centerLeft,
//                                  child: Text(
//                                    "${state.topDestination[index].details}", //"${place["details"]}",
//                                    style: TextStyle(
//                                      fontWeight: FontWeight.bold,
//                                      fontSize: 13,
//                                      color: Colors.blueGrey[300],
//                                    ),
//                                    maxLines: 1,
//                                    textAlign: TextAlign.left,
//                                  ),
//                                ),
//                              ],
//                            ),
//                          ),
//                          onTap: () {
//                            Navigator.of(context).pushNamed(
//                                TripResultScreenRoute,
//                                arguments: TripResultArgument(
//                                    pickup: AnywhereLocation,
//                                    destination:
//                                        state.topDestination[index].name,
//                                    tripDate:
//                                        DateTime.now().toIso8601String()));
//                          },
//                        ),
//                      );
//                    },
//                  );
//                } else{
//                  return new Container(width: 0.0, height: 0.0); }
//              })
          ),
        )
      ],
    );
  }
}

class TopDestinationWidget extends StatefulWidget {
  @override
  _TopDestinationWidgetState createState() => _TopDestinationWidgetState();
}

class _TopDestinationWidgetState extends State<TopDestinationWidget> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200;
  TopDestinationBloc _topDestinationBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _topDestinationBloc = BlocProvider.of<TopDestinationBloc>(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _topDestinationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopDestinationBloc, TopDestinationState>(
      builder: (context, state) {
        if (state is InitialTopDestinationState) {
          return Center(
            child: Image(
              image: new AssetImage("images/loader2.gif"),
              height: 200,
            ),
          );
        }
        if (state is TopDestinationLoading) {
          return Center(
            child: Image(
              image: new AssetImage("images/loader2.gif"),
              height: 200,
            ),
          );
        }
        if (state is TopDestinationError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image(
                  image: new AssetImage("images/error.gif"),
                  height: 200,
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      state.error.toString(),
                      style: smallTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          );
        }
        if (state is TopDestinationLoaded) {
          return ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            primary: false,
            itemCount: state.topDestination.length,
            itemBuilder: (BuildContext context, int index) {
              //Map place = places.reversed.toList()[index];
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: InkWell(
                  child: Container(
                    height: 400,
                    width: 250,
//                      color: Colors.green,
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            height: 250,
                            width: 250,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      "${state.topDestination[index].img}",
                                    ))),
                          ),
                        ),
                        SizedBox(height: 7),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${state.topDestination[index].name}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 3),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${state.topDestination[index].details}",
                            //"${place["details"]}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.blueGrey[300],
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(TripResultScreenRoute,
                        arguments: TripResultArgument(
                            pickup: AnywhereLocation,
                            destination: state.topDestination[index].name,
                            tripDate: DateTime.now().toIso8601String()));
                  },
                ),
              );
            },
          );
        } else {
          return new Container(width: 0.0, height: 0.0);
        }
      },
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {}
  }
}
