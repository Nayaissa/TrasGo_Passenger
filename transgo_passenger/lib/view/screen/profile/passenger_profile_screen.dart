import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/profile/passenger_profile_controller.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/data/model/passenger_profile_model.dart';
import 'package:transgo_passenger/view/widget/profile/passenger_profile_avatar.dart';
import 'package:transgo_passenger/view/widget/profile/profile_action_tile.dart';
import 'package:transgo_passenger/view/widget/profile/profile_info_tile.dart';
import 'package:transgo_passenger/view/widget/profile/profile_section_card.dart';
import 'package:transgo_passenger/view/widget/profile/profile_stat_card.dart';
import 'package:transgo_passenger/view/widget/state/app_state_view.dart';

class PassengerProfileScreen extends StatelessWidget {
  const PassengerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PassengerProfileControllerImp>(
      init: PassengerProfileControllerImp(),
      builder: (controller) {
        final PassengerProfileData? profile = controller.profile;

        return Scaffold(
          backgroundColor: AppColor.primaryColor,
          appBar: AppBar(
            backgroundColor: AppColor.primaryColor,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text(
              "PROFILE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
            actions: [
              IconButton(
                onPressed: profile == null ? null : controller.goToEditProfile,
                icon: Icon(
                  Icons.edit_outlined,
                  color: profile == null ? Colors.white38 : Colors.white,
                ),
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
              child: AppStateView(
                statusRequest: controller.statusRequest,
                isEmpty: controller.statusRequest == StatusRequest.success &&
                    profile == null,
                loadingMessage: "Loading profile...",
                emptyTitle: "No Profile Data",
                emptySubtitle: "Could not find your profile information.",
                errorTitle: "Failed to load profile",
                errorSubtitle: "Please try again.",
                serverErrorTitle: "Server Error",
                serverErrorSubtitle: "Could not connect to the server.",
                onRetry: () => controller.getProfile(),
                child: RefreshIndicator(
                  color: AppColor.thirdColor,
                  backgroundColor: AppColor.fifthColor,
                  onRefresh: () {
                    return controller.getProfile(showLoading: false);
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    children: [
                      if (profile != null) ...[
                        _profileHeader(profile),
                        const SizedBox(height: 18),
                        _profileStats(profile),
                        const SizedBox(height: 16),
                        _profileInfo(profile),
                        const SizedBox(height: 16),
                        _profileMenu(controller),
                        const SizedBox(height: 32),
                        _logoutButton(controller),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _profileHeader(PassengerProfileData profile) {
    return ProfileSectionCard(
      child: Column(
        children: [
          PassengerProfileAvatar(
            imageUrl: profile.photo,
            size: 96,
          ),
          const SizedBox(height: 14),
          Text(
            profile.name.isEmpty ? "Passenger" : profile.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            profile.email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.52),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileStats(PassengerProfileData profile) {
    return Row(
      children: [
        ProfileStatCard(
          title: "Completed",
          value: profile.completedReservationsCount.toString(),
          icon: Icons.check_circle_outline,
        ),
        const SizedBox(width: 10),
        ProfileStatCard(
          title: "Cancelled",
          value: profile.cancelledReservationsCount.toString(),
          icon: Icons.cancel_outlined,
        ),
        const SizedBox(width: 10),
        ProfileStatCard(
          title: "Rating",
          value: profile.ratingText,
          icon: Icons.star_border_rounded,
          highlight: true,
        ),
      ],
    );
  }

  Widget _profileInfo(PassengerProfileData profile) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ACCOUNT INFORMATION",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 18),
          ProfileInfoTile(
            icon: Icons.person_outline,
            title: "FULL NAME",
            value: profile.name,
          ),
          const SizedBox(height: 18),
          ProfileInfoTile(
            icon: Icons.email_outlined,
            title: "EMAIL ADDRESS",
            value: profile.email,
          ),
          const SizedBox(height: 18),
          ProfileInfoTile(
            icon: Icons.phone_outlined,
            title: "PHONE",
            value: profile.phoneNumber,
          ),
          const SizedBox(height: 18),
          ProfileInfoTile(
            icon: Icons.star_border_rounded,
            title: "USER RATING",
            value: "${profile.ratingText} / 5.0",
          ),
        ],
      ),
    );
  }

  Widget _profileMenu(PassengerProfileControllerImp controller) {
    return ProfileSectionCard(
      child: Column(
        children: [
          ProfileActionTile(
            icon: Icons.report_problem_outlined,
            title: "My Complaints",
            subtitle: "Resolution status",
            onTap: controller.goToComplaints,
          ),
          const SizedBox(height: 12),
          ProfileActionTile(
            icon: Icons.translate_outlined,
            title: "Language",
            subtitle: "English (US)",
            onTap: controller.goToLanguage,
          ),
          const SizedBox(height: 12),
          ProfileActionTile(
            icon: Icons.help_outline_rounded,
            title: "Help and Support",
            subtitle: "FAQs & Customer care",
            onTap: controller.goToHelpSupport,
          ),
        ],
      ),
    );
  }

  Widget _logoutButton(PassengerProfileControllerImp controller) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: controller.logout,
        icon: const Icon(
          Icons.logout_rounded,
          color: Color(0xFFFF9D8A),
          size: 19,
        ),
        label: const Text(
          "Logout",
          style: TextStyle(
            color: Color(0xFFFF9D8A),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Color(0xFFFF9D8A),
            width: 0.8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: AppColor.secondaryColor.withOpacity(0.35),
        ),
      ),
    );
  }
}
