import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naqliatsa/feature/location/data/repo/lovation_repo_impl.dart';
import 'package:naqliatsa/feature/location/ui/widget/ad_item_widget.dart';
import 'package:naqliatsa/feature/location/ui/widget/city_dropdown_widget.dart';

// import '../../data/repo/location_repo_impl.dart';
import '../../data/source/location_remote_source_impl.dart';
import '../../manager/location_cubit.dart';
import '../../manager/location_state.dart';
// import '../widget/ad_card.dart';
// import '../widget/city_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationCubit(
        LocationRepoImpl(LocationRemoteSourceImpl(FirebaseFirestore.instance)),
      )..init(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Location")),
        body: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            final cubit = context.read<LocationCubit>();

            if (state.isCitiesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CityDropdown(
                    title: "اختر المنشأ (مطلوب)",
                    value: state.fromCity,
                    cities: state.cities,
                    onChanged: (value) {
                      if (value != null) cubit.selectFromCity(value);
                    },
                  ),
                  const SizedBox(height: 12),
                  CityDropdown(
                    title: "اختر الوجهة",
                    value: state.toCity,
                    cities: state.cities,
                    onChanged: (value) {
                      if (value != null) cubit.selectToCity(value);
                    },
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: state.isAdsLoading ? null : cubit.searchAds,
                      child: state.isAdsLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("بحث عن الإعلانات"),
                    ),
                  ),

                  if (state.errorMsg != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      state.errorMsg!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],

                  const SizedBox(height: 16),

                  Expanded(
                    child: state.ads.isEmpty
                        ? const Center(child: Text("لا توجد إعلانات"))
                        : ListView.builder(
                            itemCount: state.ads.length,
                            itemBuilder: (context, index) {
                              return AdCard(ad: state.ads[index]);
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
