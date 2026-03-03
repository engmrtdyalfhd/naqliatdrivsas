// lib/feature/home/ui/view/home_view.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/helper/constant.dart';
import '../../../../core/helper/extension.dart';
import '../../../auth/data/user_truck_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const _primary = Color(0xFF1A1A2E);
  static const _accent = Color(0xFFE94560);
  static const _surface = Color(0xFFF8F9FF);

  Future<_HomeData> _loadData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final doc = await FirebaseFirestore.instance
        .collection(FirebaseStr.driversCollection)
        .doc(uid)
        .get();

    final data = doc.data() ?? {};
    final phone = data['phone'] as String? ?? '';
    final truckMap = data[FirebaseStr.driverTruck] as Map<String, dynamic>?;
    final truck = truckMap != null ? UserTruckModel.fromJson(truckMap) : null;

    return _HomeData(phone: phone, truck: truck);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: FutureBuilder<_HomeData>(
        future: _loadData(),
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: [
              _buildAppBar(snapshot.data?.phone),
              if (snapshot.connectionState == ConnectionState.waiting)
                SliverFillRemaining(child: _buildSkeleton())
              else if (snapshot.hasError)
                SliverFillRemaining(child: _buildError(snapshot.error.toString()))
              else ...[
                  SliverToBoxAdapter(child: _buildFleetCard(snapshot.data?.truck)),
                  SliverToBoxAdapter(child: _buildActionGrid(context)),
                ],
              const SliverToBoxAdapter(child: SizedBox(height: 48)),
            ],
          );
        },
      ),
    );
  }

  SliverAppBar _buildAppBar(String? phone) {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                ),
              ),
            ),
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _accent.withOpacity(0.10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(ImgPath.logo, width: 28, height: 28),
                      const SizedBox(width: 8),
                      Text(
                        phone != null ? _maskPhone(phone) : '',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFleetCard(UserTruckModel? truck) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'My Fleet', icon: Iconsax.truck),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _primary.withOpacity(0.07),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: truck == null
                ? Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No fleet data found',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            )
                : Column(
              children: [
                _FleetRow(
                  icon: Iconsax.truck,
                  iconBg: _accent.withOpacity(0.10),
                  iconColor: _accent,
                  label: 'Truck Type',
                  value: truck.truckName,
                  showDivider: true,
                ),
                _FleetRow(
                  icon: Iconsax.box,
                  iconBg: const Color(0xFF3D5AF1).withOpacity(0.10),
                  iconColor: const Color(0xFF3D5AF1),
                  label: 'Carrier',
                  value: truck.carrierType,
                  showDivider: truck.featureName != null,
                ),
                if (truck.featureName != null && truck.featureName!.isNotEmpty)
                  _FleetRow(
                    icon: Iconsax.setting_4,
                    iconBg: const Color(0xFF00BFA5).withOpacity(0.10),
                    iconColor: const Color(0xFF00BFA5),
                    label: 'Feature',
                    value: truck.featureName!,
                    showDivider: false,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'Quick Actions', icon: Iconsax.flash_1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  icon: Iconsax.location,
                  label: 'My Location',
                  color: const Color(0xFF3D5AF1),
                  onTap: () => context.pushNamed(RoutePath.locationScreen),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionCard(
                  icon: Iconsax.search_favorite,
                  label: 'Find Loads',
                  color: const Color(0xFF00BFA5),
                  onTap: () => context.pushNamed(RoutePath.searchpage),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  icon: Iconsax.user_edit,
                  label: 'Profile',
                  color: const Color(0xFFFF8C42),
                  onTap: () => context.pushNamed(RoutePath.profile),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionCard(
                  icon: Iconsax.edit,
                  label: 'Update Fleet',
                  color: _accent,
                  onTap: () => context.pushNamed(RoutePath.collection),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Shimmer(width: 100, height: 18, radius: 8),
          const SizedBox(height: 14),
          _Shimmer(width: double.infinity, height: 170, radius: 20),
          const SizedBox(height: 28),
          _Shimmer(width: 130, height: 18, radius: 8),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _Shimmer(height: 100, radius: 16)),
              const SizedBox(width: 12),
              Expanded(child: _Shimmer(height: 100, radius: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: _accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_rounded, color: _accent, size: 32),
            ),
            const SizedBox(height: 20),
            const Text('Failed to load data',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _primary)),
            const SizedBox(height: 8),
            Text(msg,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  String _maskPhone(String p) {
    if (p.length > 6) return '${p.substring(0, 4)} *** ${p.substring(p.length - 3)}';
    return p;
  }
}

class _HomeData {
  final String phone;
  final UserTruckModel? truck;
  _HomeData({required this.phone, required this.truck});
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1A1A2E)),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E), letterSpacing: -0.3,
            )),
      ],
    );
  }
}

class _FleetRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String label, value;
  final bool showDivider;

  const _FleetRow({
    required this.icon, required this.iconBg, required this.iconColor,
    required this.label, required this.value, required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500, letterSpacing: 0.4,
                        )),
                    const SizedBox(height: 2),
                    Text(value.isEmpty ? '—' : value,
                        style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        )),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.check_rounded, color: iconColor, size: 14),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, indent: 72),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(label,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
          ],
        ),
      ),
    );
  }
}

class _Shimmer extends StatefulWidget {
  final double? width;
  final double height;
  final double radius;
  const _Shimmer({this.width, required this.height, required this.radius});

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          color: Color.lerp(Colors.grey.shade200, Colors.grey.shade100, _anim.value),
        ),
      ),
    );
  }
}