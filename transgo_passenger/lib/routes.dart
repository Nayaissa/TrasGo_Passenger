import 'package:get/get.dart';
import 'package:transgo_passenger/core/constant/routes.dart';
import 'package:transgo_passenger/core/middleware/mymiddleware.dart';
import 'package:transgo_passenger/view/screen/auth/forget_password_screen.dart';
import 'package:transgo_passenger/view/screen/auth/login_screen.dart';
import 'package:transgo_passenger/view/screen/auth/otp_screen.dart';
import 'package:transgo_passenger/view/screen/auth/register_screen.dart';
import 'package:transgo_passenger/view/screen/auth/reset_password_screen.dart';
import 'package:transgo_passenger/view/screen/auth/success_reset_password_screen.dart';
import 'package:transgo_passenger/view/screen/auth/success_sign_up_screen.dart';
import 'package:transgo_passenger/view/screen/home/home_screen.dart';
import 'package:transgo_passenger/view/screen/home/category_trips_screen.dart';
import 'package:transgo_passenger/view/screen/trips/passenger_trips_screen.dart';
import 'package:transgo_passenger/view/screen/trips/trip_details_screen.dart';

List<GetPage<dynamic>>? getPages = [
  // intro.....
  GetPage(
    name: AppRoute.login,
    page: () => const LoginScreen(),
    middlewares: [MyMiddleWare()],
  ),
  GetPage(name: AppRoute.register, page: () => const RegisterScreen()),
  GetPage(name: AppRoute.verfiyCodeSignUp, page: () => VerificationScreen()),
  GetPage(name: AppRoute.successSignUp, page: () => SuccessSignUpScreen()),
  GetPage(
    name: AppRoute.successReset,
    page: () => SuccessResetPasswordScreen(),
  ),
  GetPage(name: AppRoute.forgetPassword, page: () => SendOtpScreen()),
  GetPage(name: AppRoute.resetPassword, page: () => ResetPasswordScreen()),
  //home
  GetPage(name: AppRoute.homepage, page: () => HomeScreen()),
  GetPage(name: AppRoute.categoryTrips, page: () => TripsView()),
  // trips and booking
  GetPage(name: AppRoute.passengerTrips, page: () => MyTripsView()),
  GetPage(name: AppRoute.tripDetails, page: () => TripDetailsScreen()),
];
