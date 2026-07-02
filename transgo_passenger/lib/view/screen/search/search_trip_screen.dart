import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/search/search_trip_controller.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/data/model/category_model.dart';
import 'package:transgo_passenger/data/model/trip_search_model.dart';
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
                  isEmpty: controller.statusRequest == StatusRequest.success &&
                      controller.isSearchExecuted &&
                      controller.results.isEmpty,
                  loadingMessage: "Searching trips...",
                  emptyTitle: "No Trips Found",
                  emptySubtitle: "No trips match your search filters.",
                  errorTitle: "Search Failed",
                  errorSubtitle: "Please try again.",
                  serverErrorTitle: "Server Error",
                  serverErrorSubtitle: "Could not connect to the server.",
                  onRetry: () => controller.executeSearch(),
                  child: RefreshIndicator(
                    color: AppColor.thirdColor,
                    backgroundColor: AppColor.fifthColor,
                    onRefresh: () {
                      return controller.executeSearch(showLoading: false);
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 32),
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
                        _searchCard(context, controller),
                        const SizedBox(height: 16),
                        _infoAlert(),
                        if (controller.isSearchExecuted) ...[
                          const SizedBox(height: 28),
                          _resultsHeader(controller),
                          const SizedBox(height: 14),
                          ...controller.results.map((trip) {
                            return _ResultCard(
                              trip: trip,
                              onViewDetails: () {
                                controller.viewTripDetails(trip);
                              },
                              onBookNow: () {
                               // controller.bookTrip(trip);
                              },
                            );
                          }),
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

  Widget _searchCard(BuildContext context, TripSearchControllerImp controller) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('DEPARTURE POINT'),
          _governorateField(
            context: context,
            controller: controller.departureController,
            hint: 'Start governorate',
            icon: Icons.location_on_outlined,
            searchController: controller,
            title: 'Choose departure',
            onSelected: controller.selectStartGovernorate,
          ),
          const SizedBox(height: 18),
          _label('DESTINATION'),
          _governorateField(
            context: context,
            controller: controller.destinationController,
            hint: 'End governorate',
            icon: Icons.flag_outlined,
            searchController: controller,
            title: 'Choose destination',
            onSelected: controller.selectEndGovernorate,
          ),
          const SizedBox(height: 18),
          _label('TRIP DATE'),
          _field(
            controller: controller.dateController,
            hint: 'Choose trip date',
            icon: Icons.calendar_month_outlined,
            readOnly: true,
            onTap: () => controller.pickTripDate(context),
          ),
          const SizedBox(height: 18),
          _label('TRIP TYPE'),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColor.fifthColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
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

  Widget _governorateField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required TripSearchControllerImp searchController,
    required String title,
    required ValueChanged<TripCategoryItemModel> onSelected,
  }) {
    return _field(
      controller: controller,
      hint: searchController.isLoadingGovernorates
          ? 'Loading governorates...'
          : hint,
      icon: icon,
      readOnly: true,
      suffixIcon: searchController.isLoadingGovernorates
          ? const SizedBox(
              width: 18,
              height: 18,
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.thirdColor,
                  ),
                ),
              ),
            )
          : const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white54,
            ),
      onTap: searchController.isLoadingGovernorates
          ? null
          : () => _showGovernoratesSheet(
                context: context,
                controller: searchController,
                title: title,
                onSelected: onSelected,
              ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      showCursor: !readOnly,
      cursorColor: AppColor.thirdColor,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
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
        suffixIcon: suffixIcon,
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

  void _showGovernoratesSheet({
    required BuildContext context,
    required TripSearchControllerImp controller,
    required String title,
    required ValueChanged<TripCategoryItemModel> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.68,
          ),
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
          decoration: const BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(26),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (controller.governoratesStatusRequest ==
                      StatusRequest.serverfailure ||
                  controller.governoratesStatusRequest == StatusRequest.failure)
                _governoratesError(controller)
              else if (controller.governorates.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 28),
                  child: Text(
                    'No governorates available.',
                    style: TextStyle(color: Colors.white60),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.governorates.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white10, height: 1),
                    itemBuilder: (context, index) {
                      final governorate = controller.governorates[index];

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColor.thirdColor.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.location_city_outlined,
                            color: AppColor.thirdColor,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          governorate.name ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white38,
                        ),
                        onTap: () {
                          onSelected(governorate);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _governoratesError(TripSearchControllerImp controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 26),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColor.thirdColor.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColor.thirdColor.withOpacity(0.24),
              ),
            ),
            child: const Icon(
              Icons.cloud_off_outlined,
              color: AppColor.thirdColor,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Could not load governorates',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Please try again.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.55),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.getGovernorates();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.thirdColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ],
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

  Widget _resultsHeader(TripSearchControllerImp controller) {
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
          '${controller.totalResults} FOUND',
          style: TextStyle(
            color: Colors.white.withOpacity(0.45),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
      padding: const EdgeInsets.only(
        bottom: 8,
        left: 4,
      ),
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

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.trip,
    required this.onViewDetails,
    required this.onBookNow,
  });

  final TripSearchItem trip;
  final VoidCallback onViewDetails;
  final VoidCallback onBookNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _vehicleIcon(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${trip.fromName} to ${trip.toName}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip.departureText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.52),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _tripTypeChip(trip.tripType),
            ],
          ),
          const Divider(color: Colors.white10, height: 28),
          Row(
            children: [
              Expanded(
                child: _smallInfo(
                  Icons.person_outline,
                  trip.driverName,
                ),
              ),
              Expanded(
                child: _smallInfo(
                  Icons.event_seat_outlined,
                  "${trip.availableSeats} Seats left",
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _smallInfo(
                  Icons.payments_outlined,
                  "${trip.priceText} S.P",
                  highlight: true,
                ),
              ),
              Expanded(
                child: _smallInfo(
                  Icons.route_outlined,
                  trip.distanceText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _outlineButton(
                  'VIEW DETAILS',
                  onViewDetails,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _gradientButton(
                  'BOOK NOW',
                  onBookNow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vehicleIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColor.thirdColor.withOpacity(0.14),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.directions_car_filled_outlined,
        color: AppColor.thirdColor,
      ),
    );
  }

  Widget _tripTypeChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColor.thirdColor.withOpacity(0.14),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColor.thirdColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _smallInfo(
    IconData icon,
    String text, {
    bool highlight = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color:
              highlight ? AppColor.fourthColor : Colors.white.withOpacity(0.45),
          size: 16,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text.isEmpty ? "-" : text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: highlight
                  ? AppColor.fourthColor
                  : Colors.white.withOpacity(0.55),
              fontSize: 12,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _outlineButton(
    String text,
    VoidCallback onTap,
  ) {
    return SizedBox(
      height: 46,
      child: OutlinedButton(
        onPressed: onTap,
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

  Widget _gradientButton(
    String text,
    VoidCallback onTap,
  ) {
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
        onPressed: onTap,
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
}
