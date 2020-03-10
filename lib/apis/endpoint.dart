class EndPoint {
  static const String SAFE_JOURNEY_BASE_URL = "http://174.142.93.40:64082/api/";

  static String getBookingDetailsFromReferenceURL(){
    return '$SAFE_JOURNEY_BASE_URL''BookingTransaction/GetBookingDetails';
  }

  static String getSearchBus(){
    return '$SAFE_JOURNEY_BASE_URL''Bus/MobileBusSearch';
  }

  static String getSearchStateToEverywhereBus(){
    return '$SAFE_JOURNEY_BASE_URL''Bus/MobileBusSearchFromToAnywhere';
  }


  static String getAnywhereToStateSearchBuses(){
    return '$SAFE_JOURNEY_BASE_URL''Bus/MobileBusSearchAnywhereToState';
  }
  static String getBusesTerminalByState(){
    return '$SAFE_JOURNEY_BASE_URL''Bus/PopulateAutoComplete';
  }

  static String getLoginURL() {
    return '$SAFE_JOURNEY_BASE_URL''authenticate';
  }

  static String getBookingStatus() {
    return '$SAFE_JOURNEY_BASE_URL''BookingTransaction/GetBookingDetails';
  }

  static String getRegisterPhoneURL(){
    return '$SAFE_JOURNEY_BASE_URL''';
  }

  static String getVerifiedCodeURL(){
    return '$SAFE_JOURNEY_BASE_URL''';
  }

  //POST REQUESTS BOOKING TRANSACTION
  static String postUpdateBookingPaymentReference(){
    return '$SAFE_JOURNEY_BASE_URL''BookingTransaction/UpdateBookingPayment';
  }

  static String postUpdateBookingInformation(){
    return '$SAFE_JOURNEY_BASE_URL''BookingTransaction/UpdateBookingInformation';
  }

  static String postSaveBookingInformation(){
    return '$SAFE_JOURNEY_BASE_URL''BookingTransaction/SaveBookingInformation';
  }

    static String postTestCyberspaceSetReference(){
    return 'https://payment-api.staging.cyberpay.ng/api/v1/payments';
  }

  static String getTopStateRoute(){
    return '$SAFE_JOURNEY_BASE_URL''Bus/TopDestination';
  }
}