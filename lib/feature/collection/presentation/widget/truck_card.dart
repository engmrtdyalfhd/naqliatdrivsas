import 'package:flutter/material.dart';
import 'package:naqliatdrivsas/feature/collection/data/model/truck_model.dart';

/// A selectable card that displays the truck image and name.
/// Images are loaded from assets/images/trucks/truck_<id>.png
class TruckCard extends StatelessWidget {
  const TruckCard({
    super.key,
    required this.truck,
    required this.isSelected,
    required this.onTap,
  });

  final TruckModel truck;
  final bool isSelected;
  final VoidCallback onTap;

  static const _accent = Color(0xFFE94560);
  static const _primary = Color(0xFF1A1A2E);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? _accent.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? _accent : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: _accent.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // ── Truck image ─────────────────────────────────────────────────
              SizedBox(
                width: 72,
                height: 48,
                child: Image.asset(
                  truck.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.local_shipping_outlined,
                    size: 36,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // ── Truck name ──────────────────────────────────────────────────
              Expanded(
                child: Text(
                  truck.truckName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? _primary : Colors.grey.shade800,
                  ),
                ),
              ),

              // ── Selected indicator ──────────────────────────────────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isSelected
                    ? const Icon(
                  Icons.check_circle_rounded,
                  color: _accent,
                  size: 22,
                  key: ValueKey('checked'),
                )
                    : Icon(
                  Icons.radio_button_unchecked_rounded,
                  color: Colors.grey.shade300,
                  size: 22,
                  key: const ValueKey('unchecked'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}