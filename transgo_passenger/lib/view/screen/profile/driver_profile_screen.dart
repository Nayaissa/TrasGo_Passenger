import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/profile/driver_profile_controller.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/core/shared/app_network_image.dart';
import 'package:transgo_passenger/data/model/driver_profile_model.dart';
import 'package:transgo_passenger/view/widget/profile/passenger_profile_avatar.dart';
import 'package:transgo_passenger/view/widget/profile/profile_info_tile.dart';
import 'package:transgo_passenger/view/widget/profile/profile_section_card.dart';
import 'package:transgo_passenger/view/widget/profile/profile_stat_card.dart';
import 'package:transgo_passenger/view/widget/state/app_state_view.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverProfileControllerImp>(
      init: DriverProfileControllerImp(),
      builder: (controller) {
        final DriverProfileInfo? profile = controller.profile;

        return Scaffold(
          backgroundColor: AppColor.primaryColor,
          appBar: AppBar(
            backgroundColor: AppColor.primaryColor,
            elevation: 0,
            centerTitle: true,
            title: const Text("Driver Profile"),
          ),
          body: AppStateView(
            statusRequest: controller.statusRequest,
            isEmpty: controller.statusRequest == StatusRequest.success &&
                profile == null,
            loadingMessage: "Loading driver profile...",
            emptyTitle: "No Driver Data",
            emptySubtitle: "Could not find driver profile information.",
            errorTitle: "Failed to load driver profile",
            errorSubtitle: "Please try again.",
            serverErrorTitle: "Server Error",
            serverErrorSubtitle: "Could not connect to the server.",
            onRetry: () => controller.getDriverProfile(),
            child: RefreshIndicator(
              color: AppColor.thirdColor,
              backgroundColor: AppColor.fifthColor,
              onRefresh: () {
                return controller.getDriverProfile();
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  if (profile != null) ...[
                    _buildHeader(profile),
                    const SizedBox(height: 16),
                    _buildStats(profile, controller.reviews.length),
                    const SizedBox(height: 20),
                    _buildVehicleInfo(profile),
                    const SizedBox(height: 20),
                    _buildVehicleGallery(profile.carPhotos),
                    const SizedBox(height: 20),
                    _buildReviewsList(profile, controller.reviews),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(DriverProfileInfo profile) => ProfileSectionCard(
        child: Column(
          children: [
            PassengerProfileAvatar(
              imageUrl: profile.photo,
              size: 90,
            ),
            const SizedBox(height: 10),
            Text(
              profile.name.isEmpty ? "Driver" : profile.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              profile.phoneNumber.isEmpty ? "-" : profile.phoneNumber,
              style: const TextStyle(color: Colors.white60),
            ),
          ],
        ),
      );

  Widget _buildStats(DriverProfileInfo profile, int reviewsCount) => Row(
        children: [
          ProfileStatCard(
            title: "RATING",
            value: profile.ratingText,
            icon: Icons.star_border,
          ),
          const SizedBox(width: 10),
          ProfileStatCard(
            title: "TRIPS",
            value: "0",
            icon: Icons.drive_eta,
          ),
          const SizedBox(width: 10),
          ProfileStatCard(
            title: "REVIEWS",
            value: reviewsCount.toString(),
            icon: Icons.comment_outlined,
          ),
        ],
      );

  Widget _buildVehicleInfo(DriverProfileInfo profile) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "VEHICLE INFORMATION",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 18),
          ProfileInfoTile(
            icon: Icons.directions_car,
            title: "Car Type",
            value: profile.carType,
          ),
          const SizedBox(height: 18),
          ProfileInfoTile(
            icon: Icons.category_outlined,
            title: "Category",
            value: profile.categoryName,
          ),
          const SizedBox(height: 18),
          ProfileInfoTile(
            icon: Icons.speed_outlined,
            title: "Price / KM",
            value: profile.pricePerKilometerText == "-"
                ? "-"
                : "${profile.pricePerKilometerText} S.P",
          ),
          const SizedBox(height: 18),
          ProfileInfoTile(
            icon: Icons.numbers,
            title: "Plate Number",
            
            value: profile.carPlateNumber,
          ),
          const SizedBox(height: 18),
          ProfileInfoTile(
            icon: Icons.email_outlined,
            title: "Email",
            value: profile.email,
          ),
          const SizedBox(height: 18),
          ProfileInfoTile(
            icon: Icons.phone_outlined,
            title: "Phone",
            value: profile.phoneNumber,
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleGallery(List<String> images) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "VEHICLE GALLERY",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: images.isEmpty
                ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.directions_car_filled_outlined,
                      color: Colors.white38,
                      size: 40,
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, index) => AppNetworkImage(
                      imageUrl: images[index],
                      width: 220,
                      height: 140,
                      borderRadius: 16,
                      fallbackIcon: Icons.directions_car_filled_outlined,
                      backgroundColor: Colors.white12,
                    ),
                  ),
          ),
        ],
      );

  Widget _buildReviewsList(
    DriverProfileInfo profile,
    List<DriverReviewModel> reviews,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "PASSENGER REVIEW COMMENTS",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                "Average Rating: ${profile.ratingText}",
                style: const TextStyle(color: Colors.white),
              ),
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const Spacer(),
              Text(
                "Total Comments: ${reviews.length}",
                style: const TextStyle(color: Colors.white60),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (reviews.isEmpty)
            _buildEmptyReviews()
          else
            ...reviews.map((review) => _buildReviewCard(review)),
        ],
      );

  Widget _buildEmptyReviews() => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.secondaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          "No reviews yet",
          style: TextStyle(color: Colors.white70),
        ),
      );

  Widget _buildReviewCard(DriverReviewModel review) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.secondaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.passengerName.isEmpty
                      ? "Passenger"
                      : review.passengerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  review.dateText,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            _buildRatingStars(review.rating),
            const SizedBox(height: 8),
            Text(
              review.comment.isEmpty ? "-" : review.comment,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );

  Widget _buildRatingStars(double rating) {
    final starsCount = rating.round().clamp(0, 5).toInt();

    if (starsCount == 0) {
      return const Text(
        "-",
        style: TextStyle(color: Colors.white60),
      );
    }

    return Row(
      children: List.generate(
        starsCount,
        (_) => const Icon(
          Icons.star,
          color: Colors.blueAccent,
          size: 18,
        ),
      ),
    );
  }
}
