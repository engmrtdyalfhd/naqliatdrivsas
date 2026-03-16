import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naqliatdrivsas/feature/collection/presentation/widget/truck_card.dart';

import '../../data/model/truck_model.dart';
import '../cubit/collection_cubit.dart';

class TruckSection extends StatelessWidget {
  const TruckSection({super.key, required this.trucks});

  final List<TruckModel> trucks;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionCubit, CollectionState>(
      buildWhen: (_, state) => state is TruckSelected,
      builder: (context, _) {
        final selectedId =
            context.read<CollectionCubit>().userSelection.truckId;
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: trucks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, index) {
            final truck = trucks[index];
            return TruckCard(
              truck: truck,
              isSelected: selectedId == truck.id,
              onTap: () =>
                  context.read<CollectionCubit>().selectTruck(truck),
            );
          },
        );
      },
    );
  }
}