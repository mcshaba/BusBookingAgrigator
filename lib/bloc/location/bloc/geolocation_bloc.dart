import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import './bloc.dart';

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  @override
  GeolocationState get initialState => GeoLocationStateEmpty();

  @override
  Stream<GeolocationState> mapEventToState(GeolocationEvent event) async* {
    if (event is RequestLocationEvent) {
      yield* _mapGeolocationRequestLocation();
    }
  }

  Stream<GeolocationState> _mapGeolocationRequestLocation() async* {
    Position position;
    position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    print("RETRIEVED LOCATION"); // I CAN REACH HERE EVERYTIME.
    if (position == null) {
      yield GeoLocationStateError();
    } else {
      List<Placemark> placemark = await Geolocator()
          .placemarkFromCoordinates(position.latitude, position.longitude);
      print(placemark[0].country);
      print(placemark[0].position);
      print(placemark[0].locality);
      print(placemark[0].administrativeArea);
      print(placemark[0].postalCode);
      print(placemark[0].name);
      print(placemark[0].subAdministrativeArea);
      print(placemark[0].isoCountryCode);
      print(placemark[0].subLocality);
      print(placemark[0].subThoroughfare);
      print(placemark[0].thoroughfare);
      var place = placemark[0].administrativeArea;
      yield GeoLocationSuccess(place);
    }
  }
}
