import 'package:flutter/services.dart';

class PhoneDialerService {
  static const MethodChannel _channel = MethodChannel(
    'transgo_passenger/phone_dialer',
  );

  static Future<bool> openDialer(String phoneNumber) async {
    final phone = phoneNumber.trim();

    if (phone.isEmpty) return false;

    try {
      final result = await _channel.invokeMethod<bool>(
        'openDialer',
        {
          'phone': phone,
        },
      );

      return result == true;
    } catch (error) {
      print("OPEN DIALER ERROR => $error");
      return false;
    }
  }
}
