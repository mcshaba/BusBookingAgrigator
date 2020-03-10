import 'package:safejourney/apis/safe_journey_api.dart';
import 'package:safejourney/model/booking_response.dart';
import 'package:safejourney/model/booking_status_response.dart';
import 'package:safejourney/model/post_booking.dart';
import 'package:safejourney/model/post_transaction.dart';
import 'package:safejourney/model/set_transaction_response.dart';

class BookingRepository {
  static SafeJourneyApi _api;
  static BookingRepository _instance;

  static BookingRepository getInstance(SafeJourneyApi api) {
    if (_instance == null) {
      _api = api ?? SafeJourneyApi();
      _instance = BookingRepository();
    }
    return _instance;
  }

  Future<BookingResponse> saveBooking(PostBooking booking) {

    try {
      return _api.attemptSaveBus(postBookingToJson(booking));
    } catch (e) {
      rethrow;
    }
  }


  Future<BookingStatusResponse> getBookingStatus(String bookinRef) async {
    try {
      return _api.getBookingApiStatus(bookinRef);
    } catch (error) {
      rethrow;
    }
  }

  Future<SetTransactonResponse> setTransaction(PostBooking booking) async {

    try {

      PostTransaction postTransaction =  PostTransaction(
        currency: "NGN",
        merchantRef: booking.bookingRef,
        amount: booking.amount * 100,
        description: "None",
        customerId: "1234",
        customerEmail: booking.customerName,
        customerMobile: booking.phoneNo,
        customerName: booking.customerName,
        returnUrl: "",
        integrationkey: "d79c5ad0d3a947849d77d2ff277734fa"
      );
     return _api.setCyberpayTransaction(postTransactionToJson(postTransaction));

    } catch (e) {
      rethrow;
    }
  }
}
