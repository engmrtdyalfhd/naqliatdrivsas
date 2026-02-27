import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:naqliatsa/core/helper/extension.dart';

import '../../../core/helper/constant.dart';
import '../../../core/helper/utils.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Align(
        alignment: Alignment(0, -0.9),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              CircleAvatar(radius: 56, child: Icon(Iconsax.user, size: 32)),
              const SizedBox(height: 12),
              Column(
                spacing: 3,
                children: [
                  Text(
                    "Hey There 👋",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: .w500,
                        color: Colors.grey.shade600,
                      ),
                      text: "Phone  ",
                      children: [
                        TextSpan(
                          text: FirebaseAuth.instance.currentUser?.phoneNumber,
                          style: TextStyle(fontSize: 14, fontWeight: .normal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text("Preferences", style: TextStyle(fontWeight: .w700)),
              const SizedBox(height: 2),
              ListTile(
                onTap: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: Icon(Iconsax.moon),
                title: Text("Display"),
                titleTextStyle: TextStyle(fontWeight: .normal),
                trailing: Icon(Iconsax.arrow_right_3, size: 16),
              ),
              const SizedBox(height: 1),
              ListTile(
                onTap: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: Icon(Iconsax.language_square),
                title: Text("Language"),
                titleTextStyle: TextStyle(fontWeight: .normal),
                trailing: Icon(Iconsax.arrow_right_3, size: 16),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              Text("Account", style: TextStyle(fontWeight: .w700)),
              const SizedBox(height: 2),
              ListTile(
                onTap: () async => whatsapp(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: Icon(Iconsax.headphone),
                title: Text("Customer Support"),
                titleTextStyle: TextStyle(fontWeight: .normal),
                trailing: Icon(Iconsax.arrow_right_3, size: 16),
              ),
              const SizedBox(height: 2),
              ListTile(
                onTap: () async {
                  await showConfirmationAlert(
                    context: context,
                    title: "Logout",
                    content: "Are you sure you want to logout?",
                    onConfirm: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        context.pushNamedAndRemoveUntil(
                          RoutePath.authGate,
                          (_) => false,
                        );
                      }
                    },
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: Icon(Iconsax.logout),
                title: Text("Logout"),
                // tileColor: Colors.red.shade100,
                titleTextStyle: TextStyle(fontWeight: .normal),
                trailing: Icon(Iconsax.arrow_right_3, size: 16),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  "Privacy Policy\n1.0.0",
                  textAlign: .center,
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
