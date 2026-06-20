import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/booking/book_trip_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/view/widget/state/app_loading_overlay.dart';
import 'package:transgo_passenger/view/widget/state/app_state_view.dart';

class BookTripScreen extends StatelessWidget {
  const BookTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookTripControllerImp>(
      init: BookTripControllerImp(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.primaryColor,
          appBar: AppBar(
            backgroundColor: AppColor.primaryColor,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              "Book Trip",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor.primaryColor,
                  AppColor.secondaryColor,
                ],
              ),
            ),
            child: SafeArea(
              top: false,
              child: AppLoadingOverlay(
                isLoading: controller.isConfirming,
                child: AppStateView(
                  statusRequest: controller.statusRequest,
                  loadingMessage: "Loading booking...",
                  errorTitle: "Failed to load booking",
                  errorSubtitle: "Please try again.",
                  serverErrorTitle: "Server Error",
                  serverErrorSubtitle: "Could not connect to the server.",
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _tripSummaryCard(context, controller),
                        const SizedBox(height: 16),
                        _bookingOptionsCard(controller),
                        const SizedBox(height: 24),
                        _confirmButton(controller),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _tripSummaryCard(
    BuildContext context,
    BookTripControllerImp controller,
  ) {
    return _card(
      child: Column(
        children: [
          Row(
            children: [
              _routeDots(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.from,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _titleStyle(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.to,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _titleStyle(),
                    ),
                  ],
                ),
              ),
              _chip(controller.isPrivateTrip ? "Private" : "Shared"),
            ],
          ),
          const Divider(
            color: Colors.white10,
            height: 32,
          ),
          Row(
            children: [
              Expanded(
                child: _detailItem(
                  "TIME",
                  controller.time,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _detailItem(
                  "DRIVER",
                  controller.driver,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _detailItem(
                  "PRICE",
                  "${controller.pricePerSeat.toStringAsFixed(2)} S.P",
                  isPrice: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _detailItem(
                  "TOTAL",
                  "${controller.totalPrice.toStringAsFixed(2)} S.P",
                  isPrice: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bookingOptionsCard(BookTripControllerImp controller) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("NUMBER OF SEATS"),
          const SizedBox(height: 10),
          _seatsSelector(controller),
          const SizedBox(height: 20),
          _privateTripSwitch(controller),
          const SizedBox(height: 20),
          _sectionTitle("PICKUP POINT"),
          const SizedBox(height: 10),
          _pickupPoint(controller),
          const SizedBox(height: 20),
          _sectionTitle("PAYMENT METHOD"),
          const SizedBox(height: 10),
          _paymentMethods(controller),
        ],
      ),
    );
  }

  Widget _seatsSelector(BookTripControllerImp controller) {
    return _innerBox(
      child: Row(
        children: [
          IconButton(
            onPressed:
                controller.isPrivateTrip ? null : controller.decrementSeats,
            icon: const Icon(Icons.remove),
            color: AppColor.thirdColor,
            disabledColor: Colors.white30,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "${controller.selectedSeats}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Selected seats",
                  style: TextStyle(
                    color: AppColor.hintColor,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed:
                controller.isPrivateTrip ? null : controller.incrementSeats,
            icon: const Icon(Icons.add),
            color: AppColor.thirdColor,
            disabledColor: Colors.white30,
          ),
        ],
      ),
    );
  }

  Widget _privateTripSwitch(BookTripControllerImp controller) {
    return _innerBox(
      borderColor: controller.isPrivateTrip
          ? AppColor.fourthColor.withOpacity(0.7)
          : Colors.white.withOpacity(0.08),
      child: Row(
        children: [
          const Icon(
            Icons.lock_outline,
            color: AppColor.fourthColor,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Private Trip",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "Book all remaining seats",
                  style: TextStyle(
                    color: AppColor.hintColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: controller.isPrivateTrip,
            activeColor: AppColor.fourthColor,
            inactiveThumbColor: AppColor.hintColor,
            onChanged: controller.togglePrivateTrip,
          ),
        ],
      ),
    );
  }

  Widget _pickupPoint(BookTripControllerImp controller) {
    return _innerBox(
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: AppColor.thirdColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              controller.stopPoint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentMethods(BookTripControllerImp controller) {
    return Row(
      children: [
        Expanded(
          child: _paymentCard(
            title: "Cash",
            icon: Icons.money,
            selected: controller.selectedPaymentMethod == "cash",
            onTap: () => controller.changePaymentMethod("cash"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _paymentCard(
            title: "Wallet",
            icon: Icons.account_balance_wallet_outlined,
            selected: controller.selectedPaymentMethod == "wallet",
            onTap: () => controller.changePaymentMethod("wallet"),
          ),
        ),
      ],
    );
  }

  Widget _paymentCard({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColor.fifthColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColor.fourthColor
                : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected ? AppColor.fourthColor : AppColor.hintColor,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : AppColor.hintColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _confirmButton(BookTripControllerImp controller) {
    final bool enabled = !controller.isConfirming;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: enabled
            ? const LinearGradient(
                colors: [
                  AppColor.thirdColor,
                  AppColor.fourthColor,
                ],
              )
            : null,
        color: enabled ? null : AppColor.fifthColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ElevatedButton(
        onPressed: enabled ? controller.confirmBooking : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          controller.isConfirming
              ? "Confirming..."
              : "Confirm Booking • ${controller.totalPrice.toStringAsFixed(2)} S.P",
          style: TextStyle(
            color: enabled ? Colors.white : Colors.white38,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: child,
    );
  }

  Widget _innerBox({
    required Widget child,
    Color? borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.fifthColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? Colors.white.withOpacity(0.08),
        ),
      ),
      child: child,
    );
  }

  Widget _routeDots() {
    return Column(
      children: [
        const Icon(
          Icons.radio_button_unchecked,
          color: AppColor.thirdColor,
          size: 18,
        ),
        Container(
          height: 32,
          width: 1.5,
          color: AppColor.thirdColor.withOpacity(0.35),
        ),
        const Icon(
          Icons.circle,
          color: AppColor.thirdColor,
          size: 14,
        ),
      ],
    );
  }

  Widget _detailItem(
    String title,
    String value, {
    bool isPrice = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title),
        const SizedBox(height: 5),
        Text(
          value.isEmpty ? "-" : value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isPrice ? AppColor.fourthColor : Colors.white,
            fontSize: isPrice ? 18 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColor.hintColor,
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: AppColor.fifthColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColor.thirdColor.withOpacity(0.18),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColor.thirdColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  TextStyle _titleStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    );
  }
}