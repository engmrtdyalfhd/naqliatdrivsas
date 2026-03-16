import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naqliatdrivsas/feature/collection/presentation/widget/truck_section.dart';

import '../../../../core/helper/constant.dart';
import '../../../../core/helper/extension.dart';
import '../../presentation/cubit/collection_cubit.dart';
import '../widget/carrier_feature_section.dart';
import '../widget/carrier_section.dart';

class CollectionView extends StatefulWidget {
  const CollectionView({super.key});

  @override
  State<CollectionView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  int _step = 0;

  @override
  void initState() {
    super.initState();
    // Defer until the first frame so context.locale is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context
          .read<CollectionCubit>()
          .loadTrucks(context.locale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup your account')),
      body: BlocConsumer<CollectionCubit, CollectionState>(
        listenWhen: (_, state) =>
        state is CollectionFailure || state is CollectionUpdated,
        listener: (context, state) {
          if (state is CollectionFailure) {
            context.simpleDialog(msg: state.message, lottie: ImgPath.error);
          } else if (state is CollectionUpdated) {
            context.pushNamedAndRemoveUntil(RoutePath.authGate, (_) => false);
          }
        },
        buildWhen: (_, state) =>
        state is CollectionLoaded ||
            state is CollectionLoading ||
            state is CollectionFailure,
        builder: (_, state) {
          if (state is CollectionLoading) {
            return const Center(
                child: CircularProgressIndicator.adaptive());
          }
          if (state is CollectionFailure) {
            return Center(child: Text(state.message));
          }
          if (state is CollectionLoaded) {
            return Stepper(
              currentStep: _step,
              onStepContinue: _onContinue,
              onStepCancel: _step > 0 ? _onCancel : null,
              steps: [
                Step(
                  isActive: _step >= 0,
                  title: const Text('Truck'),
                  subtitle: const Text('Select your truck type'),
                  content: TruckSection(trucks: state.trucks),
                ),
                Step(
                  isActive: _step >= 1,
                  title: const Text('Carrier'),
                  subtitle: const Text('Select a carrier type'),
                  content: const CarrierSection(),
                ),
                Step(
                  isActive: _step >= 2,
                  title: const Text('Feature'),
                  subtitle: const Text('Select a carrier feature'),
                  content: const CarrierFeatureSection(),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _onContinue() async {
    final cubit = context.read<CollectionCubit>();
    if (!cubit.isStepValid(_step)) {
      context.showMsg('Please select an option before continuing');
      return;
    }
    if (_step < 2) {
      setState(() => _step++);
    } else {
      await cubit.saveSelection();
    }
  }

  void _onCancel() {
    context.read<CollectionCubit>().resetStep(_step);
    setState(() => _step--);
  }
}