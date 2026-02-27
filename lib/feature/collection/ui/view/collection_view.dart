import '../../../../core/helper/constant.dart';
import '../../../../core/helper/extension.dart';
import '../widget/carrier_feature_section.dart';
import '../widget/carrier_section.dart';
import '../widget/truck_section.dart';
import 'package:flutter/material.dart';
import '../../manager/collection_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionView extends StatefulWidget {
  const CollectionView({super.key});

  @override
  State<CollectionView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    context.read<CollectionCubit>().getCollectionData(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Setup your account")),
      body: BlocConsumer<CollectionCubit, CollectionState>(
        buildWhen: (_, current) => current is CollectionFetched,
        listener: (_, state) {
          if (state is CollectionFailure) {
            context.simpleDialog(msg: state.error, lottie: ImgPath.error);
          } else if (state is CollectionUpdated) {
            context.pushNamedAndRemoveUntil(RoutePath.authGate, (_) => false);
          } else if (state is CollectionLoading) {
            context.simpleDialog(msg: "Loading...", lottie: ImgPath.loading);
          }
        },
        builder: (_, state) {
          if (state is CollectionFetched) {
            return Stepper(
              currentStep: _index,
              onStepContinue: () async => await _onStepContinue(context),
              onStepCancel: _index > 0
                  ? () {
                      context.read<CollectionCubit>().resetStep(_index);
                      setState(() => _index--);
                    }
                  : null,
              steps: [
                Step(
                  isActive: _index >= 0,
                  title: const Text("Truck"),
                  subtitle: const Text("Select a car type to continue"),
                  content: TruckSection(trucks: state.trucks),
                ),
                Step(
                  isActive: _index >= 1,
                  title: const Text("Carrier"),
                  subtitle: const Text("Select a carrier type to continue"),
                  content: const CarrierSection(),
                ),
                Step(
                  isActive: _index >= 2,
                  title: const Text("Feature"),
                  subtitle: const Text("Select a carrier feature to continue"),
                  content: const CarrierFeatureSection(),
                ),
              ],
            );
          } else if (state is CollectionFailure) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }

  Future<void> _onStepContinue(BuildContext context) async {
    final cubit = context.read<CollectionCubit>();
    if (cubit.isStepValid(_index)) {
      if (_index < 2) {
        setState(() => _index++);
      } else {
        await cubit.updateUserTruck();
      }
    } else {
      context.showMsg("Please select an option before contine");
    }
  }
}
