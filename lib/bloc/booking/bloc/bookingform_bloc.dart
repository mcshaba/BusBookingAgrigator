import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:safejourney/apis/safe_journey_api.dart';
import 'package:safejourney/enums/app_enums.dart';
import 'package:safejourney/model/booking_form.dart';
import 'package:safejourney/model/post_booking.dart';
import 'package:safejourney/model/search_bus_model.dart';
import 'package:safejourney/repository/booking_repository.dart';
import 'package:uuid/uuid.dart';
import './bloc.dart';

class BookingformBloc extends Bloc<BookingformEvent, BookingformState> {
  BookingRepository _bookingRepository;
  BusSchedule busSchedule;
  BookingForm bookingForm;

  BookingformBloc({
    @required BusSchedule schedule, BookingForm bookingForm,
    BookingRepository bookingRepository,
  })  : busSchedule = schedule, bookingForm = bookingForm,
        _bookingRepository = bookingRepository ??
            BookingRepository.getInstance(SafeJourneyApi());

  @override
  BookingformState get initialState => BookingFormInital(bookingForm);

  @override
  Stream<BookingformState> mapEventToState(
    BookingformEvent event,
  ) async* {
    if (event is BookingFormStarted) {
      bookingForm = BookingForm(
          coupon: '',
          passengerEmail: '',
          passengerKinEmail: '',
          passengerKinName: '',
          passengerKinPhone: '',
          passengerName: '',
          passengerPhone: '',
          schedule: busSchedule,
          tripAmount: busSchedule.promoPrice,
          seats: [],
          availableSeats: busSchedule.availableSeatsCount);
      yield BookingFormUpdated(bookingForm);
    } else if (event is UserAddsToSeat) {
      yield* _mapAddSeatsState(event);
    } else if (event is UserRemovesFromSeat) {
      yield* _mapRemovesFromSeatsState(event);
    } else if (event is PassengerNameChange) {
      yield* _mapPassengerNameChangedToState(event.name);
    } else if (event is PassengerEmailChange) {
      yield* _mapPassengerEmailChangedToState(event.email);
    } else if (event is PassengerPhoneChange) {
      yield* _mapPassengerPhoneChangedToState(event.phone);
    } else if (event is KinEmailChange) {
      yield* _mapKinEmailChangedToState(event.email);
    } else if (event is KinNameChange) {
      yield* _mapKinNameChangedToState(event.name);
    } else if (event is KinPhoneChange) {
      yield* _mapKinPhoneChangedToState(event.phone);
    } else if (event is BookingButtonPressed) {
      yield* _mapBookingSavePressed(event.bookingForm, event.transactionReference, event.payload);
    }
  }

  Stream<BookingformState> _mapPassengerEmailChangedToState(
      String email) async* {
    currentState.bookingForm.passengerEmail = email;
    yield BookingFormUpdated(currentState.bookingForm);
  }

  Stream<BookingformState> _mapPassengerNameChangedToState(String name) async* {
    currentState.bookingForm.passengerName = name;
    yield BookingFormUpdated(currentState.bookingForm);
  }

  Stream<BookingformState> _mapPassengerPhoneChangedToState(
      String phone) async* {
    currentState.bookingForm.passengerPhone = phone;
    yield BookingFormUpdated(currentState.bookingForm);
  }

  Stream<BookingformState> _mapKinEmailChangedToState(String email) async* {
    currentState.bookingForm.passengerKinEmail = email;
    yield BookingFormUpdated(currentState.bookingForm);
  }

  Stream<BookingformState> _mapKinNameChangedToState(String name) async* {
    currentState.bookingForm.passengerKinName = name;
    yield BookingFormUpdated(currentState.bookingForm);
  }

  Stream<BookingformState> _mapKinPhoneChangedToState(String phone) async* {
    currentState.bookingForm.passengerKinPhone = phone;
    yield BookingFormUpdated(currentState.bookingForm);
  }

  Stream<BookingformState> _mapAddSeatsState(UserAddsToSeat event) async* {
    int seatsCount = currentState.bookingForm.availableSeats - 1;

    currentState.bookingForm.seats.add(event.seatNumber.toString());
    var form = BookingForm(
        coupon: currentState.bookingForm.coupon,
        passengerEmail: currentState.bookingForm.passengerEmail,
        passengerKinEmail: currentState.bookingForm.passengerKinEmail,
        passengerKinName: currentState.bookingForm.passengerKinName,
        passengerKinPhone: currentState.bookingForm.passengerKinPhone,
        passengerName: currentState.bookingForm.passengerKinName,
        passengerPhone: currentState.bookingForm.passengerPhone,
        schedule: currentState.bookingForm.schedule,
        tripAmount: currentState.bookingForm.schedule.promoPrice *
            currentState.bookingForm.seats.length,
        seats: currentState.bookingForm.seats,
        availableSeats: seatsCount);
    yield BookingFormUpdated(form);
  }

  Stream<BookingformState> _mapRemovesFromSeatsState(
      UserRemovesFromSeat event) async* {
    int seatsCount = currentState.bookingForm.availableSeats + 1;
    currentState.bookingForm.seats.remove(event.seatNumber.toString());
    var form = BookingForm(
        coupon: currentState.bookingForm.coupon,
        passengerEmail: currentState.bookingForm.passengerEmail,
        passengerKinEmail: currentState.bookingForm.passengerKinEmail,
        passengerKinName: currentState.bookingForm.passengerKinName,
        passengerKinPhone: currentState.bookingForm.passengerKinPhone,
        passengerName: currentState.bookingForm.passengerKinName,
        passengerPhone: currentState.bookingForm.passengerPhone,
        schedule: currentState.bookingForm.schedule,
        tripAmount: currentState.bookingForm.schedule.promoPrice *
            currentState.bookingForm.seats.length,
        seats: currentState.bookingForm.seats,
        availableSeats: seatsCount);
    yield BookingFormUpdated(form);
  }

  Stream<BookingformState> _mapBookingSavePressed(BookingForm bookingForm, String transactionReference, String payload) async* {
    yield BookingFormSaveLoading(bookingForm);
    try {
      PostBooking booking = PostBooking(
        virtualBusId: currentState.bookingForm.schedule.virtualBusId,
        bookingRef: Uuid().v1(), //time-based unique id
        customerName: currentState.bookingForm.passengerName,
        email: currentState.bookingForm.passengerEmail,
        phoneNo: currentState.bookingForm.passengerPhone,
        coupon: 0, //? Should this be a number
        departureTime: currentState.bookingForm.schedule.departureTime,
        departureId: currentState.bookingForm.schedule.departureId,
        destination: currentState.bookingForm.schedule.destination,
        departure: currentState.bookingForm.schedule.departure,
        destinationId: currentState.bookingForm.schedule.destinationId,
        amount: bookingForm.tripAmount.toInt(),
        bookingStatus: BoookingStatus.paid.index,
        bookingDate: DateTime.now(),
        tripDate: currentState.bookingForm.schedule.tripdate,
        seatNumber: currentState.bookingForm.seats, //! this shouldn't be int,
        tenantId: currentState.bookingForm.schedule.tenantId,
        nextOfKinName: currentState.bookingForm.passengerKinName,
        nkPhoneNo: currentState.bookingForm.passengerKinPhone,
        nkEmail: currentState.bookingForm.passengerKinEmail,
        status: "2",
        paymentReference: transactionReference,
        payload: payload,
      );
      var bookingResponse = await _bookingRepository.saveBooking(booking);
//      var response = await _bookingRepository.setTransaction(booking);
      yield BookingFormSaveSuccess(
          bookingReference: bookingResponse.bookingRef,
          bookingForm: currentState.bookingForm);
    } catch (e) {
      yield BookingFormSaveFailure(
          error: e.toString() ?? "An error occurred while saving your booking",
          bookingForm: currentState.bookingForm);
    }
  }
}
