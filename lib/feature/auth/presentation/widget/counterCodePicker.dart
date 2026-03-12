import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/colory.dart';

class CountryCodePicker extends StatelessWidget {
  const CountryCodePicker({
    super.key,
    required this.selectedCode,
    required this.onTap,
  });

  final String selectedCode;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colory.lightBg,
          border: Border.all(color: Colors.blue.shade50),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          spacing: 16,
          children: [
            Text(selectedCode),
            const Icon(Iconsax.arrow_down_1, size: 16),
          ],
        ),
      ),
    );
  }
}

class CountryCodeBottomSheet extends StatelessWidget {
  const CountryCodeBottomSheet({super.key});

  static const List<Map<String, String>> _countries = [
    {'name': 'Saudi Arabia', 'code': '+966', 'flag': '🇸🇦'},
    {'name': 'Egypt', 'code': '+20', 'flag': '🇪🇬'},
    {'name': 'Yemen', 'code': '+967', 'flag': '🇾🇪'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Select country',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _countries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final country = _countries[index];
                return ListTile(
                  leading: Text(
                    country['flag']!,
                    style: const TextStyle(fontSize: 18),
                  ),
                  title: Text(
                    country['name']!,
                    style: const TextStyle(fontSize: 13),
                  ),
                  trailing: Text(
                    country['code']!,
                    style: const TextStyle(fontSize: 13),
                  ),
                  onTap: () => Navigator.pop(context, country['code']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}