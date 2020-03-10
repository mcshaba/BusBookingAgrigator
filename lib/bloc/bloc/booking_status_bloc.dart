import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:safejourney/apis/safe_journey_api.dart';
import 'package:safejourney/repository/booking_repository.dart';
import './bloc.dart';

class BookingStatusBloc extends Bloc<BookingStatusEvent, BookingStatusState> {
  BookingRepository _bookingRepository;

  BookingStatusBloc({
    BookingRepository tripRepository,
  }) : _bookingRepository =
            tripRepository ?? BookingRepository.getInstance(SafeJourneyApi());

  @override
  BookingStatusState get initialState => InitialBookingStatusState();

  @override
  Stream<BookingStatusState> mapEventToState(
    BookingStatusEvent event,
  ) async* {
    if (event is StatusClickEvent) {
      String reference = event.bookRef;
      yield* _mapStatusPressed(reference);
    }
  }

  Stream<BookingStatusState> _mapStatusPressed(String reference) async* {
    yield BookingStatusLoading();
    try {
      var bookingResponse =
          await _bookingRepository.getBookingStatus(reference);
      yield BookingStatusSuccess(
        bookingStatusResponse: bookingResponse,
      );
    } catch (e) {
      yield BookingStatusFailure(
        error: e.toString() ??
            "An error occurred while getting your booking reference",
      );
    }
  }
}
