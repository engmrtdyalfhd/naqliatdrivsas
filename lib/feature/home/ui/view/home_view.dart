// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
// import 'package:naqliatsa/feature/search/ui/view/search_page.dart';
// import 'package:naqliatsa/feature/search/data/cubits/search_cubit.dart';
// import 'package:naqliatsa/feature/search/ui/view/search_page.dart' as Routes;
// import 'package:naqliatsa/feature/search/ui/view/search_page.dart';
// import 'package:naqliatsa/feature/search/ui/view/search_page.dart' as Routes;
import '../../../../core/helper/constant.dart';
import '../../../../core/helper/extension.dart';
// import '../../../search/ui/view/search_page.dart';
// import '../../../search/ui/view/search_page.dart' as Routes show SearchPage;

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset(ImgPath.logo, width: 64, height: 64)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 128),
        // crossAxisAlignment: .stretch,
        children: [
          const Header(title: "My Fleet"),
          const SizedBox(height: 12),
          ListTile(
            onTap: () {},
            dense: true,
            trailing: const Icon(Iconsax.car),
            title: const Text('Truck name'),
            subtitle: Text("Car name here"),
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: ListTile(
                  onTap: () {},
                  dense: true,
                  title: const Text('Carrier type'),
                  subtitle: Text("Car name here"),
                ),
              ),
              Expanded(
                child: ListTile(
                  onTap: () {},
                  dense: true,
                  title: const Text('Carrier feature'),
                  subtitle: Text("Car name here"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Header(title: "Location"),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Iconsax.location),
            title: const Text('Location'),
            subtitle: Text("Laboris et amet culpa dolore minim."),
            onTap: () {},
          ),
          const SizedBox(height: 32),
          const Header(title: "Search"),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Iconsax.search_favorite),
            title: const Text('Search'),
            subtitle: const Text("Laboris et amet culpa dolore minim."),
            onTap: () {
              // استدعاء دالة الـ Cubit
              context.pushReplacementNamed(RoutePath.searchpage);
            },
          ),
          // ListTile(
          //   leading: const Icon(Iconsax.search_favorite),
          //   title: const Text('Search'),
          //   subtitle: Text("Laboris et amet culpa dolore minim."),
          //   onTap: () {},
          // ),
          const SizedBox(height: 32),
          Header(title: "History", onSeeAll: () {}),
          // const SizedBox(height: 8),
          SizedBox(
            height: context.query.size.height * .2,
            child: ListView.separated(
              itemCount: 6,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.query.size.height * .1,
                      ),
                      child: Text("Item $index"),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) => const SizedBox(width: 8),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async => context.pushNamed(RoutePath.profile),
        label: const Text("Settings"),
        icon: const Icon(Iconsax.setting_2),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String title;
  final void Function()? onSeeAll;
  const Header({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        Text(title, style: TextStyle(fontSize: 16, fontWeight: .w500)),
        if (onSeeAll != null) ...[
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: Text("See all", style: TextStyle(fontSize: 11)),
          ),
        ],
      ],
    );
  }
}
