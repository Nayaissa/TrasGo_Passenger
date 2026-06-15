import 'package:flutter/material.dart';
import 'package:transgo_passenger/controller/home/category_trip_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class TripsInlineFilterCard extends StatelessWidget {
  const TripsInlineFilterCard({
    super.key,
    required this.controller,
  });

  final TripsController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: controller.showFilters
          ? Container(
              key: const ValueKey("filters_open"),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter Trips",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "All filters are optional",
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 18),

                  _FilterDropdownField(
                    label: "START POINT",
                    hint: "Choose start point",
                    icon: Icons.my_location_outlined,
                    value: controller.selectedStartPoint,
                    items: controller.startPoints,
                    onChanged: controller.changeStartPoint,
                  ),

                  const SizedBox(height: 14),

                  _FilterDropdownField(
                    label: "DEPARTURE DATE",
                    hint: "Choose departure date",
                    icon: Icons.calendar_today_outlined,
                    value: controller.selectedDepartureDate,
                    items: controller.departureDateOptions,
                    onChanged: controller.changeDepartureDate,
                  ),

                  const SizedBox(height: 14),

                  _FilterDropdownField(
                    label: "TRIP TYPE",
                    hint: "Choose trip type",
                    icon: Icons.directions_bus_outlined,
                    value: controller.selectedTripType,
                    items: controller.tripTypes,
                    onChanged: controller.changeTripType,
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: OutlinedButton(
                            onPressed: controller.clearFilters,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.18),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              "Clear",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              colors: [
                                AppColor.thirdColor,
                                AppColor.fourthColor,
                              ],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: controller.applyFilters,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              "Apply",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox(
              key: ValueKey("filters_closed"),
              height: 0,
            ),
    );
  }
}

class _FilterDropdownField extends StatelessWidget {
  const _FilterDropdownField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final IconData icon;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.hintColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: value,
          dropdownColor: AppColor.fifthColor,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: theme.hintColor,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: theme.hintColor.withOpacity(0.65),
              fontSize: 13,
            ),
            prefixIcon: Icon(
              icon,
              color: theme.hintColor,
              size: 20,
            ),
            filled: true,
            fillColor: AppColor.fifthColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.06),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColor.thirdColor,
              ),
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}