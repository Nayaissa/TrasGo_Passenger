import 'package:get/get.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';

abstract class BookTripController extends GetxController {
  void incrementSeats();
  void decrementSeats();
  void togglePrivateTrip(bool value);
  void changePaymentMethod(String method);
  Future<void> confirmBooking();
}

class BookTripControllerImp extends BookTripController {
  StatusRequest statusRequest = StatusRequest.success;

  final String from = "Damascus";
  final String to = "Aleppo";
  final String time = "Today, 08:30 PM";
  final String driver = "Ahmad Kareem";
  final double pricePerSeat = 12.50;
  final int maxAvailableSeats = 3;
  final String stopPoint = "Central Station";

  int selectedSeats = 2;
  bool isPrivateTrip = false;
  bool isConfirming = false;
  String selectedPaymentMethod = "wallet";

  double get totalPrice {
    return selectedSeats * pricePerSeat;
  }

  bool get canConfirm {
    return !isConfirming && selectedSeats > 0;
  }

  @override
  void incrementSeats() {
    if (isPrivateTrip) return;

    if (selectedSeats < maxAvailableSeats) {
      selectedSeats++;
      update();
    }
  }

  @override
  void decrementSeats() {
    if (isPrivateTrip) return;

    if (selectedSeats > 1) {
      selectedSeats--;
      update();
    }
  }

  @override
  void togglePrivateTrip(bool value) {
    isPrivateTrip = value;

    if (isPrivateTrip) {
      selectedSeats = maxAvailableSeats;
    } else {
      selectedSeats = 1;
    }

    update();
  }

  @override
  void changePaymentMethod(String method) {
    selectedPaymentMethod = method;
    update();
  }

  @override
  Future<void> confirmBooking() async {
    if (!canConfirm) return;

    isConfirming = true;
    update();

    await Future.delayed(const Duration(milliseconds: 700));

    isConfirming = false;
    update();

    Get.snackbar(
      "Booking",
      "Your trip has been booked successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}