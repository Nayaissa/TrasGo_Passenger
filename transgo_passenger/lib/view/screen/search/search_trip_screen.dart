import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/search/search_trip_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/view/widget/state/app_loading_overlay.dart';
import 'package:transgo_passenger/view/widget/state/app_state_view.dart';

class TripSearchView extends StatelessWidget {
  const TripSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripSearchControllerImp>(
      init: TripSearchControllerImp(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.primaryColor,
          appBar: AppBar(
            backgroundColor: AppColor.primaryColor,
            elevation: 0,
            centerTitle: true,
            leading: const Icon(Icons.menu, color: Colors.white),
            title: const Text(
              'Find Trip',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.notifications_none, color: Colors.white),
              ),
            ],
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
                isLoading: controller.isSearching,
                child: AppStateView(
                  statusRequest: controller.statusRequest,
                  loadingMessage: "Searching trips...",
                  errorTitle: "Search Failed",
                  errorSubtitle: "Please try again.",
                  serverErrorTitle: "Server Error",
                  serverErrorSubtitle: "Could not connect to the server.",
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Where are you going?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Find shared or private trips that match your route.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.50),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _searchCard(controller),
                        const SizedBox(height: 16),
                        _infoAlert(),
                        if (controller.isSearchExecuted) ...[
                          const SizedBox(height: 28),
                          _resultsHeader(),
                          const SizedBox(height: 14),
                          _resultCard(),
                        ],
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

  Widget _searchCard(TripSearchControllerImp controller) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('DEPARTURE POINT'),
          _field(
            controller: controller.departureController,
            hint: 'Enter departure city',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 18),
          _label('DESTINATION'),
          _field(
            controller: controller.destinationController,
            hint: 'Where to?',
            icon: Icons.flag_outlined,
          ),
          const SizedBox(height: 18),
          _label('TRIP DATE'),
          _field(
            controller: controller.dateController,
            hint: 'mm/dd/yyyy',
            icon: Icons.calendar_month_outlined,
          ),
          const SizedBox(height: 18),
          _label('TRIP TYPE'),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColor.fifthColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Row(
              children: [
                _typeButton(
                  'SHARED',
                  controller.tripType == 'SHARED',
                  () => controller.setTripType('SHARED'),
                ),
                _typeButton(
                  'PRIVATE',
                  controller.tripType == 'PRIVATE',
                  () => controller.setTripType('PRIVATE'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _searchButton(controller),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      cursorColor: AppColor.thirdColor,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.35),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: AppColor.thirdColor,
          size: 20,
        ),
        filled: true,
        fillColor: AppColor.fifthColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColor.thirdColor,
          ),
        ),
      ),
    );
  }

  Widget _typeButton(String text, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppColor.thirdColor.withOpacity(0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColor.thirdColor.withOpacity(0.30)
                  : Colors.transparent,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white54,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchButton(TripSearchControllerImp controller) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColor.thirdColor,
            AppColor.fourthColor,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ElevatedButton(
        onPressed: controller.isSearching ? null : controller.executeSearch,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          controller.isSearching ? 'Searching...' : 'Search Trips',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _infoAlert() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColor.fifthColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColor.thirdColor.withOpacity(0.20),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColor.thirdColor,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Results include exact matches and routes passing through the governorate.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Search Results',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '12 FOUND',
          style: TextStyle(
            color: Colors.white.withOpacity(0.45),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _resultCard() {
    return _card(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColor.thirdColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.directions_car_filled_outlined,
                  color: AppColor.thirdColor,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Damascus to Homs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'May 01, 12:00 PM',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                '2,000',
                style: TextStyle(
                  color: AppColor.fourthColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 28),
          Row(
            children: [
              Expanded(
                child: _smallInfo(
                  Icons.person_outline,
                  'DR. NAYA',
                ),
              ),
              Expanded(
                child: _smallInfo(
                  Icons.event_seat_outlined,
                  '4 Seats left',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _outlineButton('VIEW DETAILS'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _gradientButton('BOOK NOW'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.45),
          size: 16,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.55),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _outlineButton(String text) {
    return SizedBox(
      height: 46,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.white.withOpacity(0.12),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _gradientButton(String text) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColor.thirdColor,
            AppColor.fourthColor,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _card({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(20),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: child,
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.45),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}