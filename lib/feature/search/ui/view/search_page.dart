// lib/feature/search/ui/view/search_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/cubits/search_cubit.dart';
import '../../data/model/saudi_city.dart';
import '../../data/model/shipment_model.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  static const _primary = Color(0xFF1A1A2E);
  static const _accent = Color(0xFFE94560);
  static const _green = Color(0xFF00C853);
  static const _surface = Color(0xFFF8F9FF);

  @override
  Widget build(BuildContext context) {
    // Load cities once when page opens
    context.read<SearchCubit>().loadCities();

    return Scaffold(
      backgroundColor: _surface,
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          final cubit = context.read<SearchCubit>();

          // // Show error snackbar
          // if (state.errorMsg != null) {
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(content: Text(state.errorMsg!)),
          //     );
          //   });
          // }

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
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                ),
                centerTitle: true,
              ),

              // ── Route Selector Card ──────────────────────
              SliverToBoxAdapter(
                child: _buildRouteCard(context, state, cubit),
              ),

              // ── Results ──────────────────────────────────
              if (state.isShipmentsLoading)
                SliverFillRemaining(
                  child: const Center(
                    child: CircularProgressIndicator(color: _accent),
                  ),
                )
              else if (state.hasSearched && state.shipments.isEmpty)
                SliverToBoxAdapter(child: _buildEmpty())
              else if (state.shipments.isNotEmpty) ...[
                  SliverToBoxAdapter(child: _buildResultsHeader(state)),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (_, i) => _ShipmentCard(shipment: state.shipments[i]),
                      childCount: state.shipments.length,
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

  // ── Route Selector Card ────────────────────────────────
  Widget _buildRouteCard(
      BuildContext context,
      SearchState state,
      SearchCubit cubit,
      ) {
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
            trailing: Icon(
              Iconsax.location,
              size: 16,
              color: Colors.grey.shade400,
            ),
            child: state.isCitiesLoading
                ? const Text('جاري التحميل...',
                style: TextStyle(color: Colors.grey))
                : _CityPickerButton(
              hint: 'اختر المنشأ',
              value: state.fromCity,
              cities: state.cities,
              onSelected: cubit.selectFromCity,
            ),
          ),

          // Dotted connector + swap button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const SizedBox(width: 10),
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
                const Spacer(),
                // Swap button
                GestureDetector(
                  onTap: cubit.swapCities,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _primary.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.swap_vert_rounded,
                      size: 18,
                      color: _primary,
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
            trailing: Icon(
              Icons.expand_more,
              size: 20,
              color: Colors.grey.shade400,
            ),
            child: state.isCitiesLoading
                ? const Text('جاري التحميل...',
                style: TextStyle(color: Colors.grey))
                : _CityPickerButton(
              hint: 'اختر الوجهة',
              value: state.toCity,
              cities: state.cities,
              onSelected: cubit.selectToCity,
            ),
          ),

          // Search button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed:
                state.isShipmentsLoading ? null : cubit.searchShipments,
                icon: const Icon(Iconsax.search_normal, size: 18),
                label: const Text(
                  'بحث عن الحمولات',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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

  Widget _buildResultsHeader(SearchState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${state.shipments.length} حمولة',
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
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

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
            child: Icon(
              Iconsax.box_remove,
              size: 32,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'لم يتم العثور على حمولات',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'لا توجد حمولات على هذا المسار حالياً',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

// ── Route Row ─────────────────────────────────────────────────
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

// ── City Picker — opens a searchable bottom sheet ─────────────
class _CityPickerButton extends StatelessWidget {
  final String hint;
  final String? value;
  final List<SaudiCity> cities;
  final ValueChanged<String> onSelected;

  const _CityPickerButton({
    required this.hint,
    required this.value,
    required this.cities,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPicker(context),
      child: Text(
        value ?? hint,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: value != null ? const Color(0xFF1A1A2E) : Colors.grey,
        ),
      ),
    );
  }

  void _openPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CitySearchSheet(
        cities: cities,
        onSelected: (city) {
          Navigator.pop(context);
          onSelected(city);
        },
      ),
    );
  }
}

// ── Searchable city bottom sheet ──────────────────────────────
class _CitySearchSheet extends StatefulWidget {
  final List<SaudiCity> cities;
  final ValueChanged<String> onSelected;

  const _CitySearchSheet({
    required this.cities,
    required this.onSelected,
  });

  @override
  State<_CitySearchSheet> createState() => _CitySearchSheetState();
}

class _CitySearchSheetState extends State<_CitySearchSheet> {
  static const _primary = Color(0xFF1A1A2E);
  late List<SaudiCity> _filtered;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.cities;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = query.isEmpty
          ? widget.cities
          : widget.cities
          .where((c) =>
      c.name.contains(query) || c.region.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  'اختر المدينة',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _primary,
                  ),
                ),
              ),
              // Search field
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _controller,
                  onChanged: _onSearch,
                  // textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن مدينة أو منطقة...',
                    // hintTextDirection: TextDirection.rtl,
                    prefixIcon: const Icon(Iconsax.search_normal, size: 18),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              // City list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _filtered.length,
                  itemBuilder: (_, i) {
                    final city = _filtered[i];
                    // Show region header when it changes
                    final showHeader = i == 0 ||
                        _filtered[i - 1].region != city.region;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showHeader)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                            child: Text(
                              city.region,
                              // textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ListTile(
                          dense: true,
                          title: Text(
                            city.name,
                            // textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 15,
                              color: _primary,
                            ),
                          ),
                          trailing: const Icon(
                            Iconsax.location,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () => widget.onSelected(city.name),
                        ),
                        const Divider(height: 1, indent: 16),
                      ],
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
}

// ── Shipment Card ─────────────────────────────────────────────
class _ShipmentCard extends StatelessWidget {
  final Shipment shipment;
  const _ShipmentCard({required this.shipment});

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
          // ── Time ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy/MM/dd').format(shipment.createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                  ),
                ),
                if (shipment.distanceKm > 0)
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${shipment.distanceKm.toStringAsFixed(0)} كم',
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

          // ── Route line ────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _green,
                  ),
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

          // ── City names ────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  shipment.originCity,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _primary,
                  ),
                ),
                Text(
                  shipment.destinationCity,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _primary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  shipment.originCountry,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                Text(
                  shipment.destinationCountry,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Divider(height: 1),

          // ── Description + call button ──────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    shipment.description,
                    style: const TextStyle(fontSize: 13, color: _primary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    // textDirection: TextDirection.rtl,
                  ),
                ),
                if (shipment.phone != null) ...[
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => launchUrl(
                      Uri.parse('tel:${shipment.phone}'),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: _green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.phone, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'اتصل',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.5;
    const dashWidth = 4.0;
    const dashSpace = 3.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}