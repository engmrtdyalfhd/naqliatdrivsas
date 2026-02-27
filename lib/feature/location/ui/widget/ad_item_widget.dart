import 'package:flutter/material.dart';
import 'package:naqliatsa/feature/location/data/model/admodel.dart';
// import '../../data/model/ad_model.dart';

class AdCard extends StatelessWidget {
  final AdModel ad;

  const AdCard({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(ad.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(ad.description),
            const SizedBox(height: 6),
            Text("من: ${ad.from}  ➝  إلى: ${ad.to}"),
          ],
        ),
      ),
    );
  }
}
