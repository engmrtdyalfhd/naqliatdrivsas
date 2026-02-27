import 'package:flutter/material.dart';
import '../../manager/collection_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarrierSection extends StatelessWidget {
  const CarrierSection({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<CollectionCubit>();
    return BlocBuilder<CollectionCubit, CollectionState>(
      builder: (_, state) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: read.carriers.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            return RadioMenuButton(
              value: read.carriers[index].id,
              groupValue: read.userSelection.carrierId,
              onChanged: (val) {
                context.read<CollectionCubit>().selectCarrier(
                  read.carriers[index],
                );
              },
              child: Text(read.carriers[index].carrierType),
            );
          },
        );
      },
    );
  }
}
