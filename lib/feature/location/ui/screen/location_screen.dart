// lib/feature/location/ui/screen/location_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/model/admodel.dart';
import '../../data/model/city_model.dart';
import '../../manager/location_cubit.dart';
import '../../manager/location_state.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  static const _primary = Color(0xFF1A1A2E);
  static const _accent = Color(0xFFE94560);
  static const _green = Color(0xFF00C853);
  static const _surface = Color(0xFFF8F9FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          final cubit = context.read<LocationCubit>();
          return CustomScrollView(
            slivers: [
              // ── Header ──────────────────────────────────
              SliverAppBar(
                pinned: true,
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                expandedHeight: 0,
                title: const Text(
                  'البحث عن حمولة',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                centerTitle: true,
              ),

              // ── Route Selector Card ──────────────────────
              SliverToBoxAdapter(
                child: _buildRouteCard(context, state, cubit),
              ),

              // ── Results ──────────────────────────────────
              if (state.isAdsLoading)
                SliverFillRemaining(child: _buildLoading())
              else if (state.hasSearched && state.ads.isEmpty)
                SliverToBoxAdapter(child: _buildEmpty())
              else if (state.ads.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: _buildResultsHeader(state),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (_, i) => _AdCard(ad: state.ads[i]),
                      childCount: state.ads.length,
                    ),
                  ),
                ],

              const SliverToBoxAdapter(child: SizedBox(height: 48)),
            ],
          );
        },
      ),
    );
  }

  // ── Route Selector Card ──────────────────────────────────
  Widget _buildRouteCard(
      BuildContext context, LocationState state, LocationCubit cubit) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // FROM row
          _RouteRow(
            dotColor: _green,
            label: 'المنشأ',
            trailing: state.isGpsLoading
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Icon(Iconsax.location, size: 16, color: Colors.grey.shade400),
            child: state.isCitiesLoading
                ? const Text('جاري التحميل...',
                style: TextStyle(color: Colors.grey))
                : _CityPicker(
              hint: 'اختر المنشأ',
              value: state.fromCity,
              cities: state.cities,
              onChanged: (v) {
                if (v != null) cubit.selectFromCity(v);
              },
            ),
          ),

          // Dotted connector
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Row(
              children: [
                Column(
                  children: List.generate(
                    4,
                        (_) => Container(
                      width: 2,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // TO row
          _RouteRow(
            dotColor: _accent,
            label: 'الوجهة',
            trailing:
            Icon(Icons.expand_more, size: 20, color: Colors.grey.shade400),
            child: state.isCitiesLoading
                ? const Text('جاري التحميل...',
                style: TextStyle(color: Colors.grey))
                : _CityPicker(
              hint: 'اختر الوجهة',
              value: state.toCity,
              cities: state.cities,
              onChanged: (v) {
                if (v != null) cubit.selectToCity(v);
              },
            ),
          ),

          // Search button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: state.isAdsLoading ? null : cubit.searchAds,
                icon: const Icon(Iconsax.search_normal, size: 18),
                label: const Text(
                  'بحث عن الإعلانات',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: _accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader(LocationState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${state.ads.length} إعلان',
              style: const TextStyle(
                color: _accent,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'من ${state.fromCity} إلى ${state.toCity}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() => const Center(
    child: CircularProgressIndicator(color: _accent),
  );

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child:
            Icon(Iconsax.box_remove, size: 32, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 16),
          const Text(
            'لم يتم العثور على بضائع',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'لا توجد إعلانات على هذا المسار حالياً',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

// ── Route Row ────────────────────────────────────────────────
class _RouteRow extends StatelessWidget {
  final Color dotColor;
  final String label;
  final Widget child;
  final Widget trailing;

  const _RouteRow({
    required this.dotColor,
    required this.label,
    required this.child,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
              boxShadow: [
                BoxShadow(
                  color: dotColor.withOpacity(0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                child,
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

// ── City Picker (inline dropdown) ────────────────────────────
class _CityPicker extends StatelessWidget {
  final String hint;
  final String? value;
  final List<CityModel> cities;
  final ValueChanged<String?> onChanged;

  const _CityPicker({
    required this.hint,
    required this.value,
    required this.cities,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        hint: Text(
          hint,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        isExpanded: true,
        isDense: true,
        icon: const SizedBox.shrink(),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A2E),
        ),
        items: cities
            .map((c) => DropdownMenuItem(
          value: c.name,
          child: Text(c.name),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

// ── Ad Card ──────────────────────────────────────────────────
class _AdCard extends StatelessWidget {
  final AdModel ad;
  const _AdCard({required this.ad});

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
          // ── Top: time ago ──────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (ad.timeAgo.isNotEmpty)
                  Text(
                    ad.timeAgo,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                    ),
                  ),
                if (ad.distanceKm != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
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

          // ── Route line ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                // From dot
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _green,
                  ),
                ),
                // Dashed line
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: CustomPaint(
                      painter: _DashedLinePainter(),
                      child: const SizedBox(height: 1),
                    ),
                  ),
                ),
                // To dot
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _accent,
                  ),
                ),
              ],
            ),
          ),

          // ── City names ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad.from,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _primary,
                      ),
                    ),
                    if (ad.fromRegion.isNotEmpty)
                      Text(
                        ad.fromRegion,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      ad.to,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _primary,
                      ),
                    ),
                    if (ad.toRegion.isNotEmpty)
                      Text(
                        ad.toRegion,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Divider(height: 1),

          // ── Cargo info ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ad.title.isNotEmpty)
                  Row(
                    children: [
                      Icon(Iconsax.box, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Text(
                        ad.title,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                if (ad.cargoType != null && ad.cargoType!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Iconsax.note_text, size: 14,
                          color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Text(
                        'الوصف: ${ad.cargoType}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
                if (ad.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    ad.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Contact button ───────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: ad.phone != null
                    ? () => _callPhone(ad.phone!)
                    : null,
                icon: const Icon(Icons.phone_rounded, size: 16),
                label: const Text(
                  'الاتصال بصاحب الحمولة',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: _accent,
                  disabledBackgroundColor: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _callPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }
}

// ── Dashed line painter ───────────────────────────────────────
class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 4.0;
    const dashSpace = 3.0;
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.5;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}