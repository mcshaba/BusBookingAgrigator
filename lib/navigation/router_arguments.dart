import 'package:meta/meta.dart';
import 'package:safejourney/constants/routing_constants.dart';
import 'package:safejourney/repository/user_repository.dart';

class TripResultArgument {
  String pickup;
  String destination;
  String tripDate;

  TripResultArgument({
    @required this.pickup,
    this.destination = AnywhereLocation,
    @required this.tripDate,
  }) : assert(pickup != null);
}

