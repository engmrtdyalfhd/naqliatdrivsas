import 'package:flutter/material.dart';
import '../../data/model/city_model.dart';

class CityDropdown extends StatelessWidget {
  final String title;
  final String? value;
  final List<CityModel> cities;
  final void Function(String?) onChanged;

  const CityDropdown({
    super.key,
    required this.title,
    required this.value,
    required this.cities,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: title),
      items: cities
          .map(
            (city) =>
                DropdownMenuItem(value: city.name, child: Text(city.name)),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
