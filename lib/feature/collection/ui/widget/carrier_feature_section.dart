import 'package:flutter/material.dart';
import '../../manager/collection_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarrierFeatureSection extends StatelessWidget {
  const CarrierFeatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<CollectionCubit>();
    return BlocBuilder<CollectionCubit, CollectionState>(
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: read.features.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            return RadioMenuButton(
              value: read.features[index].id,
              groupValue: read.userSelection.featureId,
              onChanged: (val) {
                context.read<CollectionCubit>().selectFeature(
                  read.features[index],
                );
              },
              child: Text(read.features[index].name),
            );
          },
        );
      },
    );
  }
}
