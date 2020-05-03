import 'package:http/src/client.dart' as HTTP;
import 'package:thesis/models/Booking.dart';
import 'package:thesis/modules/FakeService.dart';

import 'BaseService.dart';
import 'EasyTableBookingService.dart';

class ServicesFactory {
  static BaseService getService(BookingTypes bookingType, {HTTP.Client client}) {
    switch (bookingType) {
      case BookingTypes.DineEasyCallBooking:
        return FakeService();
      case BookingTypes.EasyTableBooking:
        return EasyTableBookingService(client);
      case BookingTypes.NoBooking:
      default:
        return null;
    }
  }
}
