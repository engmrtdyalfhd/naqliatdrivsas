import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/truck_model.dart';
import '../../manager/collection_cubit.dart';

class TruckSection extends StatelessWidget {
  final List<TruckModel> trucks;

  const TruckSection({super.key, required this.trucks});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionCubit, CollectionState>(
      buildWhen: (_, current) => current is TruckSelected,
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: trucks.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            return RadioMenuButton(
              value: trucks[index].id,
              groupValue: context.read<CollectionCubit>().userSelection.truckId,
              onChanged: (val) => _onChanged(context, index),
              child: Text(trucks[index].truckName),
            );
          },
        );
      },
    );
  }

  void _onChanged(BuildContext context, int index) {
    context.read<CollectionCubit>().selectTruck(trucks[index]);
  }
}
