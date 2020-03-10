import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:safejourney/constants/routing_constants.dart';
import 'package:safejourney/model/search_bus_model.dart';
import 'package:safejourney/screens/trip_result_view.dart';
import 'package:safejourney/widgets/airport_detail_widget.dart';
import 'package:safejourney/widgets/line_dash_widget.dart';
import 'package:safejourney/widgets/location_widget.dart';

class TicketCardWidget extends StatelessWidget {
  final BusSchedule ticket;
  final bool showQR;

  TicketCardWidget({@required this.ticket, this.showQR = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF4F2EF),
      height: 220.0,
      child: Card(
        color: Color(0xffF4F2EF),
        elevation: 0.0,
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(BookingScreenRoute, arguments: ticket);
          },
          child: Container(
            margin: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          LocationWidget(
                            stationName: ticket.departure == null ? "-- --" : ticket.departure,
                            cityName: ticket.departure == null ? "-- --" : ticket.departure,
                            time: ticket.departureTime == null ? "-- --" : ticket.departureTime,
                            destinationName: ticket.destinationTerminal == null ? "-- --" : ticket.destinationTerminal,
                            destCityName: ticket.destination == null ? "-- --" : ticket.destination,
                            destTime: '---',
                          ),
                        ],
                      ),
                      SizedBox(height: 24.0),
                      Container(
                        // height: 0.5,
                        // color: Colors.white,
                        padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                        child: const LineDashedPainter(color: Colors.blueGrey),
                      ),
                      SizedBox(height: 24.0),
                      AirportDetailWidget(
                        transport: ticket.tenantName == null ? "-- --" : ticket.tenantName,
                        price: ticket.promoPrice  == null ? "-- --" :
                        '${NumberFormat("###.0#", "en_US").format(ticket.promoPrice)}',
                        actualPrice: ticket.actualPrice == null? "-- --": 
                        '${NumberFormat("###.0#", "en.US").format(ticket.actualPrice)}' ,
                        seats: ticket.seatCapacity == null ? "-- --" : ticket.seatCapacity.toString(),
                      ),
                      // SizedBox(height: 8.0),
                      // Container(
                      //     width: double.infinity,
                      //     child: OutlineButton(
                      //       textColor: Colors.white,
                      //       shape: UnderlineInputBorder(
                      //         borderSide: BorderSide(
                      //           color: Colors.white, //Color of the border
                      //           style: BorderStyle.solid, //Style of the border
                      //           width: 0.8, //width of the border
                      //         ),
                      //         // borderRadius: BorderRadius.only(
                      //         //     topLeft: Radius.circular(4.0),
                      //         //     topRight: Radius.circular(4.0)),
                      //       ),
                      //       color: Colors.transparent,
                      //       child: Text('N${ticket.newPrice}/ Adult'),
                      //       onPressed: () {},
                      //     ))
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                showQR
                    ? Container()
                    // Hero(
                    //     tag: "qrcode",
                    //     child: Image.asset(
                    //       "images/qrcode.png",
                    //       width: 80.0,
                    //       color: Colors.white,
                    //     ),
                    //   )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
