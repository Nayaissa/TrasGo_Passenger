import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/data/model/cancel_booking_model.dart';

class CancelBookingResultDialog extends StatelessWidget {
  const CancelBookingResultDialog({
    super.key,
    required this.model,
  });

  final CancelBookingModel model;

  @override
  Widget build(BuildContext context) {
    final data = model.data;
    final penalty = data?.penalty;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "تم إلغاء الحجز",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          model.message ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColor.hintColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _SectionTitle(title: "ملخص الحجز"),
              const SizedBox(height: 10),
              _InfoRow(
                label: "رقم الحجز",
                value: data?.bookingCode ?? "-",
              ),
              _InfoRow(
                label: "الحالة",
                value: data?.status?.name ?? "ملغى",
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      icon: Icons.schedule_outlined,
                      label: "قبل الانطلاق",
                      value: _formatHours(penalty?.hoursBeforeDeparture),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricBox(
                      icon: Icons.account_balance_wallet_outlined,
                      label: "استرداد المحفظة",
                      value: _formatMoney(penalty?.walletRefundAmount),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SectionTitle(title: "المعلومات المالية"),
              const SizedBox(height: 10),
              _InfoRow(
                label: "فترة السماح",
                value: penalty?.gracePeriodApplied == true ? "مطبقة" : "غير مطبقة",
              ),
              _InfoRow(
                label: "نسبة الغرامة",
                value: _formatPercent(penalty?.percentage),
              ),
              _InfoRow(
                label: "مبلغ الغرامة",
                value: _formatMoney(penalty?.amount),
              ),
              _InfoRow(
                label: "تأثير التقييم",
                value: _formatNumber(penalty?.ratingPenalty),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.fourthColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "حسنًا",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatMoney(double? value) {
    if (value == null) return "-";
    return "${_formatNumber(value)} ل.س";
  }

  String _formatHours(double? value) {
    if (value == null) return "-";
    return "${_formatNumber(value)} ساعة";
  }

  String _formatPercent(double? value) {
    if (value == null) return "-";
    return "${_formatNumber(value)}%";
  }

  String _formatNumber(double? value) {
    if (value == null) return "-";

    if (value.truncateToDouble() == value) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColor.hintColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      // minHeight: 88,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.fifthColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColor.fourthColor,
            size: 20,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColor.hintColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: AppColor.fifthColor.withOpacity(0.72),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColor.hintColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
