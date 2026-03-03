// lib/feature/location/ui/widget/ad_item_widget.dart
// Updated to use new AdModel fields (from/to instead of originCity/destinationCity)

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/model/admodel.dart';

class AdCard extends StatelessWidget {
  final AdModel ad;
  const AdCard({super.key, required this.ad});

  static const _primary = Color(0xFF1A1A2E);
  static const _accent = Color(0xFFE94560);
  static const _green = Color(0xFF00C853);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Time & distance ──────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ad.timeAgo,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                ),
                if (ad.distanceKm != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${ad.distanceKm!.toStringAsFixed(0)} Km',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Dashed route line ────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                Container(
                  width: 10, height: 10,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: _green),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: CustomPaint(
                      painter: _DashedLinePainter(),
                      child: const SizedBox(height: 1),
                    ),
                  ),
                ),
                Container(
                  width: 10, height: 10,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: _accent),
                ),
              ],
            ),
          ),

          // ── City names ───────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ad.from,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700, color: _primary)),
                    if (ad.fromRegion.isNotEmpty)
                      Text(ad.fromRegion,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(ad.to,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700, color: _primary)),
                    if (ad.toRegion.isNotEmpty)
                      Text(ad.toRegion,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Divider(height: 1),

          // ── Cargo info ───────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ad.title.isNotEmpty)
                  Row(children: [
                    Icon(Iconsax.box, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text(ad.title,
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                  ]),
                if (ad.cargoType != null && ad.cargoType!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Iconsax.note_text, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text('الوصف: ${ad.cargoType}',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                  ]),
                ],
                if (ad.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(ad.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ],
            ),
          ),

          // ── Contact button ───────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: ad.phone != null ? () => _call(ad.phone!) : null,
                icon: const Icon(Icons.phone_rounded, size: 16),
                label: const Text('الاتصال بصاحب الحمولة',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                style: FilledButton.styleFrom(
                  backgroundColor: _accent,
                  disabledBackgroundColor: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 4.0;
    const dashSpace = 3.0;
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.5;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}