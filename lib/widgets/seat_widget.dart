import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safejourney/bloc/booking/bloc/bookingform_bloc.dart';
import 'package:safejourney/bloc/booking/bloc/bookingform_event.dart';
import 'package:safejourney/themes/styles.dart';

class SeatView extends StatefulWidget {
  @override
  _SeatViewState createState() => _SeatViewState();
}

class _SeatViewState extends State<SeatView>
    with AutomaticKeepAliveClientMixin<SeatView> {
  BookingformBloc _busBookingBloc;
  List<String> gridState;

  @override
  void initState() {
    super.initState();
    _busBookingBloc = BlocProvider.of<BookingformBloc>(context);
    convertSeatsToWidget();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      child: _buildBusBody(),
    );
  }

  convertSeatsToWidget() {
//    String unavailbleSeatPositions = _busBookingBloc.busSchedule.unavailableSeats.isEmpty ? "" :
//        _busBookingBloc.busSchedule.unavailableSeats.join(',');

    List<String> unavailableSeats = _busBookingBloc.busSchedule.unavailableSeats;
//    var allBookedSeatPosition = _busBookingBloc.busSchedule.allBookedSeats;


    gridState = List(_busBookingBloc.busSchedule.seatCapacity);

    //? Refactor for efficiency
    for (var i = 0; i < _busBookingBloc.busSchedule.seatCapacity; i++) {
      gridState[i] = '';
    }
//    allBookedSeatPosition.split(',').forEach((seatNumber) {
//      try {
//        var seatPosition = int.parse(seatNumber);
//        gridState[seatPosition - 1] = 'B';
//      } catch (err) {}
//    });

    if(unavailableSeats.length == 0){

    } else {
//      unavailbleSeatPositions.split(',').forEach((seatNumber) {
      unavailableSeats.forEach((seatNumber) {
        try {
          var seatPosition = int.parse(seatNumber);
          gridState[seatPosition - 1] = 'X';
        } catch (err) {
          //log error
        }
      }
      );
    }
    // 1. get value of seats, and convert seats to a list of string
    // 2. get unavailable seat numbers, and insert into list of string, then mark the remaining as available
  }

  addSeatToSelectedSeat(int seatPosition) {
    // _busBookingBloc.schedule.availableSeatsCount--;
    _busBookingBloc.dispatch(UserAddsToSeat(seatPosition));
  }

  removeSeatFromSelectedSeats(int seatPosition) {
    // _busBookingBloc.schedule.availableSeatsCount++;
    _busBookingBloc.dispatch(UserRemovesFromSeat(seatPosition));
  }

  Widget _buildBusBody() {
    int gridStateLength = gridState.length;
    return Column(children: <Widget>[
      AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          // decoration: BoxDecoration(
          //     border: Border.all(color: Colors.black, width: 2.0)),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              //  crossAxisSpacing: 4.0,
              // mainAxisSpacing: 4.0,
            ),
            itemBuilder: _buildGridItems,
            itemCount: gridStateLength,
          ),
        ),
      ),
    ]);
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int seatNumber =
        index + 1; //*done so that 0 index will not be shown as a seat number

    return GestureDetector(
      // onTap: () => _gridItemTapped(x, y),
      onTap: () {
        print('Tapped seat - $seatNumber');
        if (gridState[index] == 'X' || gridState[index] == 'B') {
          return;
        }
        setState(() {
          if (gridState[index] == 'S') {
            gridState[index] = '';
            removeSeatFromSelectedSeats(seatNumber);
          } else {
            gridState[index] = 'S';
            addSeatToSelectedSeat(seatNumber);
          }
        });
      },
      child: Center(
        child: GridTile(
          child: Center(
            child: _buildGridItem(index),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(int index) {
    int seatNumber = index + 1;
    // if (index == 0) {
    //   return Container();
    // }
    switch (gridState[index]) {
      case '': //* Available seats
        return Container(
            width: 40,
            height: 40,
            child: Center(child: Text('$seatNumber')),
            decoration: new BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xffffffff), width: 1)));
        break;
      case 'X': //* Unavailable seats
        return new Container(
            width: 60,
            height: 60,
            child: Center(
              child: Text('$seatNumber',
                  style: TextStyle(color: Colors.white, fontSize: 16.0)),
            ),
            decoration: new BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Color(0xffffffff), width: 1)));
        break;
      case 'S': //* Selected seats
        return new Container(
            width: 60,
            height: 60,
            child: Center(
              child: Text('$seatNumber',
                  style: TextStyle(color: Colors.white, fontSize: 16.0)),
            ),
            decoration: new BoxDecoration(
                color: Color(0xff80bf31),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Color(0xffffffff), width: 1)));
        break;
      case 'B': //* Booked seats
        return new Container(
            width: 60,
            height: 60,
            child: Center(
              child: Text('$seatNumber',
                  style: TextStyle(color: Colors.white, fontSize: 16.0)),
            ),
            decoration: new BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Color(0xffffffff), width: 1)));
        break;
      default:
        return Text(gridState[index].toString());
    }
  }

  @override
  bool get wantKeepAlive => true;
}
