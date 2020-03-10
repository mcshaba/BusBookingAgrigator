import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:safejourney/model/LoginResponse.dart';
import 'package:safejourney/model/book_transaction.dart';
import 'package:safejourney/model/booking_response.dart';
import 'package:safejourney/model/booking_status_response.dart';
import 'package:safejourney/model/payment_reference_response.dart';
import 'package:safejourney/model/search_bus_model.dart';
import 'package:safejourney/model/set_transaction_response.dart';
import 'package:safejourney/model/state_terminal_response.dart';
import 'package:safejourney/model/top_destination.dart';
import 'package:safejourney/utilities/exceptions.dart';

import 'endpoint.dart';

class SafeJourneyApi {
  //Load State Json from Assets file
  Future<String> loadStateFromAsset() async {
    return await rootBundle.loadString('assets/state.json');
  }

  Future<BookingStatusResponse> getBookingApiStatus(String bookingRef) async {
    Response response;
    Dio dio = Dio();
    print('$bookingRef');

    try {
      response = await dio.get(EndPoint.getBookingStatus(), queryParameters: {
        "bookingRef": bookingRef,
      });
      print('$response');

      if (response.statusCode == 200) {
        return BookingStatusResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to get Booking result for bus');
      }
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      throw Exception(_handleError(error));
    }
  }

  Future<SearchBusResponse> getSearchBus(String fromState, String toState,
      DateTime tripDate, int noofAdults) async {
    Response response;
    Dio dio = Dio();

    try {
      response = await dio.get(EndPoint.getSearchBus(), queryParameters: {
        "fromState": fromState,
        "toState": toState,
        "tripDate": tripDate,
        "noofAdults": noofAdults
      });
//      print('$response');

      if (response.statusCode == 200) {
        print('${response.data}');
        //SearchBusResponse searchBusResponse = SearchBusResponse.fromJson(json.decode(response.data));
        return SearchBusResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to search bus');
      }
    } catch (error) {
      if (error is DioError) {
        print(error.response);

        if (error.response?.statusCode == 400) {
          var value = BookTransactionResponse.fromJson(error.response?.data);
          throw CleanerException(value.message);
        } else if (error.response?.statusCode == 502) {
          var value = BookTransactionResponse.fromJson(error.response?.data);
          throw CleanerException(value.message);
        } else {
          throw CleanerException(_handleError(error));
        }
      } else {
        throw CleanerException(
            'We are having issues reaching the server. Try again later.');
      }
    }
  }

  Future<SearchBusResponse> getStateToEveryWhereBuses(
      String fromState, DateTime tripDate, int noofAdults) async {
    Response response;
    Dio dio = Dio();

    try {
      response = await dio.get(EndPoint.getSearchStateToEverywhereBus(),
          queryParameters: {
            "fromState": fromState,
            "tripDate": tripDate,
            "noofAdults": noofAdults
          });
      print('$response');

      if (response.statusCode == 200) {
        print('${response.data}');
        //SearchBusResponse searchBusResponse = SearchBusResponse.fromJson(json.decode(response.data));
        return SearchBusResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to search bus');
      }
    } catch (error) {
      if (error is DioError) {
        print(error.response);

        if (error.response?.statusCode == 400) {
          var value = BookTransactionResponse.fromJson(error.response?.data);
          throw CleanerException(value.message);
        } else if (error.response?.statusCode == 502) {
          var value = BookTransactionResponse.fromJson(error.response?.data);
          throw CleanerException(value.message);
        } else {
          throw CleanerException(_handleError(error));
        }
      } else {
        throw CleanerException(
            'We are having issues reaching the server. Try again later.');
      }
    }
  }

  Future<SearchBusResponse> getAnywhereToStateBuses(
      String toState, DateTime tripDate, int noofAdults) async {
    Response response;
    Dio dio = Dio();

    try {
      response = await dio.get(EndPoint.getAnywhereToStateSearchBuses(),
          queryParameters: {
            "toState": toState,
            "tripDate": tripDate,
            "noofAdults": noofAdults
          });
      print('$response');

      if (response.statusCode == 200) {
        print('${response.data}');
        //SearchBusResponse searchBusResponse = SearchBusResponse.fromJson(json.decode(response.data));
        return SearchBusResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to search bus');
      }
    } catch (error) {
      if (error is DioError) {
        print(error.response);

        if (error.response?.statusCode == 400) {
          var value = BookTransactionResponse.fromJson(error.response?.data);
          throw CleanerException(value.message);
        } else if (error.response?.statusCode == 502) {
          var value = BookTransactionResponse.fromJson(error.response?.data);
          throw CleanerException(value.message);
        } else {
          throw CleanerException(_handleError(error));
        }
      } else {
        throw CleanerException(
            'We are having issues reaching the server. Try again later.');
      }
    }
  }

  //Get Booking Details With Reference
  Future<BookTransactionResponse> getBookingDetailsWithReference(
      String bookingRef) async {
    Response response;

    Dio dio = Dio(); //    dio.options.headers = {'Authorization': 'Bearer '};
    try {
      response = await dio.get(EndPoint.getBookingDetailsFromReferenceURL(),
          queryParameters: {"bookingRef": bookingRef});

      if (response.statusCode == 200) {
        BookTransactionResponse bookTransactionResponse =
            BookTransactionResponse.fromJson(response.data);
        return bookTransactionResponse;
      } else {
        throw Exception('Failed to create booking');
      }
    } catch (error) {
      if (error is DioError) {
        print(error.response);

        if (error.response?.statusCode == 400) {
          var value = BookTransactionResponse.fromJson(error.response?.data);
          throw Exception(value.message);
        } else if (error.response?.statusCode == 502) {
          var value = BookTransactionResponse.fromJson(error.response?.data);
          throw Exception(value.message);
        } else {
          throw Exception(_handleError(error));
        }
      } else if (error is Error) {
        throw CleanerException(
            'We are get any bus status for booking reference $bookingRef. \n Kindly  check booking ref and Try again later.');
      } else {
        throw Exception(
            'We are having issues reaching the server. Try again later.');
      }
    }
  }

  //Get Booking Details With Reference
  Future<StateTerminalResponse> getBusesTerminalByState(String state) async {
    Response response;

    Dio dio = Dio(); //    dio.options.headers = {'Authorization': 'Bearer '};
    try {
      response = await dio.get(EndPoint.getBusesTerminalByState(),
          queryParameters: {"text": state});

      var statusCode = response.statusCode;
      print(statusCode.toString());

      if (statusCode == 200) {
        return StateTerminalResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load States');
      }
    } catch (error) {
      if (error is DioError) {
        print(error.response);

        if (error.response?.statusCode == 400) {
          var value = StateTerminalResponse.fromJson(error.response?.data);
          throw Exception(value.toString());
        } else if (error.response?.statusCode == 502) {
          var value = StateTerminalResponse.fromJson(error.response?.data);
          throw Exception(value.toString());
        } else {
          throw Exception(_handleError(error));
        }
      } else {
        throw Exception(
            'We are having issues reaching the server. Try again later.');
      }
    }
  }

  Future getVerification() async {
    Response response;
    Dio dio = Dio();
    try {
      response = await dio.get(EndPoint.getVerifiedCodeURL());
      if (response.statusCode == 200) {
        BookTransactionResponse bookTransactionResponse =
            BookTransactionResponse.fromJson(response.data);
        return bookTransactionResponse;
      } else {
        throw Exception('Failed to create booking');
      }
    } catch (error) {
      if (error is DioError) {
        if (error.response?.statusCode == 400) {
          var value = BookTransactionResponse.fromJson(error.response?.data);
          throw Exception(value.message);
        } else if (error.response?.statusCode == 502) {
          var value = BookTransactionResponse.fromJson(error.response?.data);
          throw Exception(value.message);
        } else {
          throw Exception(_handleError(error));
        }
      } else {
        throw Exception('We are having issues sending the. Try again later.');
      }
    }
  }

  Future getPhoneRegistration() async {
    Response response;
    Dio dio = Dio();
    try {
      response = await dio.get('${EndPoint.getRegisterPhoneURL()}');

      if (response.statusCode == 200) {
        BookTransactionResponse phoneResponse =
            BookTransactionResponse.fromJson(response.data);
        return phoneResponse;
      } else if (response.statusCode == 400) {
        var value = BookTransactionResponse.fromJson(response.data);
        throw Exception(value.data.toString());
      } else {
        throw Exception('Booking Transaction Failed');
      }
    } catch (error) {
      if (error is DioError) {
        print(error.response);

        if (error.response?.statusCode == 400) {
          var value = BookTransactionResponse.fromJson(error.response?.data);
          throw Exception(value.message);
        } else if (error.response?.statusCode == 502) {
          var value = BookTransactionResponse.fromJson(error.response?.data);
          throw Exception(value.message);
        } else {
          throw Exception(_handleError(error));
        }
      } else {
        throw Exception(
            'We are having issues sending the account to the server. Try again later.');
      }
    }
  }

  Future<LoginResponse> fetchLogin(String phoneNumber) async {
    Response response;
    Dio dio = Dio();

    try {
      response = await dio.post(EndPoint.getLoginURL(), data: {
        "PhoneNumber": phoneNumber,
      });

      print('$response');

      if (response.statusCode == 200) {
        print('${response.data}');

        return LoginResponse.fromJson(response.data);
      }

      if (response.statusCode == 400) {
        var value = LoginResponse.fromJson(response.data);
        throw Exception(value.data.responseMessage);
      } else {
        throw Exception("Login failed");
      }
    } catch (error) {
      if (error is DioError) {
        print(error.response);

        if (error.response?.statusCode == 400) {
          var value = LoginResponse.fromJson(error.response?.data);
          throw Exception(value.message);
        } else if (error.response?.statusCode == 502) {
          var value = LoginResponse.fromJson(error.response?.data);
          throw Exception(value.message);
        } else {
          throw Exception(_handleError(error));
        }
      } else {
        throw Exception(
            'We are having issues sending the account to the server. Try again later. ');
      }
    }
  }

  String _handleError(DioError error) {
    String errorDescription = "";
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.CANCEL:
          errorDescription =
              "Request to API server was cancelled \n Kindly check your internet connection and try again";
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errorDescription =
              "Connection timeout with API server \n Kindly check your internet connection and try again";
          break;

        case DioErrorType.SEND_TIMEOUT:
          errorDescription =
              "Send timeout in connection with API server \n Kindly check your internet connection and try again";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errorDescription =
              "Sorry, there are No Buses available on this route \n Kindly check your internet connection and try again";

          break;
        case DioErrorType.RESPONSE:
          if (error.response?.statusCode == 401) {
            errorDescription = "401. Session expired. Kindly login again.";
          } else {
            errorDescription =
                "Sorry, there are No Buses available on this route";
            // errorDescription =
            //     "Received invalid staus code: ${error.response.statusCode}";
          }
          break;
        case DioErrorType.DEFAULT:
          errorDescription =
              "Slow or no internet connection. Please check your internet settings and try again.";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured";
    }
    return errorDescription;
  }

  Future<BookingResponse> attemptSaveBus(String encodedJson) async {
    Response response;
    Dio dio = new Dio();
    print('encodedJson: $encodedJson');

    try {
      response = await dio.post("${EndPoint.postSaveBookingInformation()}",
          data: encodedJson);

      if (response.statusCode == 200) {
        print('${response.data}');
        return BookingResponse.fromJson(response.data);
      }
      if (response.statusCode == 201) {
        print('${response.data}');
        return BookingResponse.fromJson(response.data);
      } else {
        return BookingResponse.fromJson(response.data);
      }
    } catch (error) {
      print(error);
      if (error is DioError) {
        throw CleanerException(_handleError(error));
      } else {
        throw CleanerException(
            'We are having issues sending the account to the server. Try again later. ');
      }
    }
  }

  Future<List<TopDestination>> getTopStateRoute() async{
    Response response;
    Dio dio = new Dio();

    try{
      response = await dio.get("${EndPoint.getTopStateRoute()}");

      if(response.statusCode == 200){
        var jsonData = response.data;
        List<TopDestination> topDestinations = [];

        for(var topDest in jsonData){
          TopDestination topDestination = TopDestination( name: topDest["name"],
            img: topDest["img"],
            details: topDest["details"],
          );
          topDestinations.add(topDestination);
        }
    return topDestinations;


      }else {
        throw CleanerException('We are not able to reach the server at this time. Try again later.');
      }
    }catch(error){
      print(error);
      if(error is DioError){
        throw CleanerException(_handleError(error));
      } else {
        throw CleanerException('We are not able to reach the server at this time. Try again later.');
      }
    }
  }

  Future<SetTransactonResponse> setCyberpayTransaction(
      String encodedJson) async {
    Response response;
    Dio dio = new Dio();

    try {
      response = await dio.post("${EndPoint.postTestCyberspaceSetReference()}",
          data: encodedJson);

      print('Response: $response');

      if (response.statusCode == 200) {
        print('${response.data}');
        return SetTransactonResponse.fromJson(response.data);
      }
      if (response.statusCode == 201) {
        print('${response.data}');
        return SetTransactonResponse.fromJson(response.data);
      } else {
        return SetTransactonResponse.fromJson(response.data);
      }
    } catch (error) {
      print(error);
      if (error is DioError) {
        throw CleanerException(_handleError(error));
      } else {
        throw CleanerException(
            'We are having issues sending the account to the server. Try again later. ');
      }
    }
  }

  Future<PaymentVerificationResponse> updateBookingPayment(
      String paymentReference) async {
    Response response;
    Dio dio = new Dio();

    try {
      response = await dio.post(EndPoint.postUpdateBookingPaymentReference(),
          data: {"PaymentReference": paymentReference});
      print('$response');

      if (response.statusCode == 200) {
        print('${response.data}');

        return PaymentVerificationResponse.fromJson(response.data);
      }
      if (response.statusCode == 400) {
        var value = PaymentVerificationResponse.fromJson(response.data);
        throw Exception(value.data.destination);
      } else {
        return PaymentVerificationResponse.fromJson(response.data);
      }
    } catch (error) {
      if (error is DioError) {
        print(error.response);

        if (error.response?.statusCode == 400) {
          var value =
              PaymentVerificationResponse.fromJson(error.response?.data);
          //throw Exception(value.message);
        } else if (error.response?.statusCode == 502) {
          var value =
              PaymentVerificationResponse.fromJson(error.response?.data);
          //throw Exception(value.message);
        } else {
          throw Exception(_handleError(error));
        }
      } else {
        throw Exception(
            'We are having issues sending the reference to the server. Try again later. ');
      }
    }
  }

  Future<PaymentVerificationResponse> updateBookingInformation(
      String payload, String paymentReference, String bookingRef) async {
    Response response;
    Dio dio = new Dio();

    try {
      response = await dio.post(EndPoint.postUpdateBookingInformation(), data: {
        "Payload": payload,
        "PaymentReference": paymentReference,
        "BookingRef": bookingRef
      });

      print('$response');

      if (response.statusCode == 200) {
        print('${response.data}');

        return PaymentVerificationResponse.fromJson(response.data);
      }
      if (response.statusCode == 400) {
        var value = PaymentVerificationResponse.fromJson(response.data);
        throw Exception(value.data.destination);
      } else {
        return PaymentVerificationResponse.fromJson(response.data);
      }
    } catch (error) {
      if (error is DioError) {
        print(error.response);

        if (error.response?.statusCode == 400) {
          var value =
              PaymentVerificationResponse.fromJson(error.response?.data);
          //throw Exception(value.message);
        } else if (error.response?.statusCode == 502) {
          var value =
              PaymentVerificationResponse.fromJson(error.response?.data);
          //throw Exception(value.message);
        } else {
          throw Exception(_handleError(error));
        }
      } else {
        throw Exception(
            'We are having issues sending the reference to the server. Try again later. ');
      }
    }
  }
}

enum Error {
  NoSuchMethodError,
}
