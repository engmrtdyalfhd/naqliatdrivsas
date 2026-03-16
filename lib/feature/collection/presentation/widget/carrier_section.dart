import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/cubit/collection_cubit.dart';

class CarrierSection extends StatelessWidget {
  const CarrierSection({super.key});

  static const _primaryColor = Color(0xFF1A1A2E);
  static const _accentColor = Color(0xFFE94560);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionCubit, CollectionState>(
      builder: (_, state) {
        final cubit = context.read<CollectionCubit>();
        final selected = cubit.userSelection.carrierId;

        if (cubit.carriers.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                'No carriers available for selected truck',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          itemCount: cubit.carriers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, index) {
            final carrier = cubit.carriers[index];
            final isSelected = selected == carrier.id;
            return _SelectionTile(
              label: carrier.carrierType,
              isSelected: isSelected,
              onTap: () => context.read<CollectionCubit>().selectCarrier(carrier),
              accentColor: _accentColor,
              primaryColor: _primaryColor,
            );
          },
        );
      },
    );
  }
}

class _SelectionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;
  final Color primaryColor;

  const _SelectionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? accentColor.withOpacity(0.06) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? accentColor : Colors.grey.shade200,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? accentColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? accentColor : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? primaryColor : Colors.grey.shade700,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: accentColor),
            ],
          ),
        ),
      ),
    );
  }
}