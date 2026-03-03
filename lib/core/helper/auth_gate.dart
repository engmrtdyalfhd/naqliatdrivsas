// lib/core/helper/auth_gate.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../feature/auth/data/user_model.dart';
import '../../feature/auth/manager/auth_cubit.dart';
import '../../feature/auth/ui/view/login_view.dart';
import '../../feature/collection/data/repo/collection_repo.dart';
import '../../feature/collection/manager/collection_cubit.dart';
import '../../feature/collection/ui/view/collection_view.dart';
import '../../feature/home/ui/view/home_view.dart';
import 'constant.dart';
import '../service/service_locator.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        // 1. Auth loading
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold();
        }

        // 2. Not logged in → Login
        if (authSnapshot.data == null) {
          return BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(),
            // Builder widget creates a NEW context that is a descendant
            // of BlocProvider, so LoginView can find AuthCubit correctly.
            child: Builder(builder: (_) => const LoginView()),
          );
        }

        // 3. Logged in → check Firestore
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection(FirebaseStr.driversCollection)
              .doc(authSnapshot.data!.uid)
              .get(),
          builder: (context, dbSnapshot) {
            if (dbSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold();
            }

            if (dbSnapshot.hasError) {
              return const Scaffold(
                body: Center(child: Text("Oops! Auth gate error.")),
              );
            }

            final docData = dbSnapshot.data?.data();
            final bool hasTruck =
                dbSnapshot.data != null &&
                    dbSnapshot.data!.exists &&
                    docData != null &&
                    (docData as Map<String, dynamic>)['truck'] != null;

            if (hasTruck) {
              try {
                final user =
                UserModel.fromJson(docData as Map<String, dynamic>);
                if (user.truck != null) return const HomeView();
              } catch (_) {}
            }

            // Logged in but no truck → fleet setup
            return BlocProvider<CollectionCubit>(
              create: (_) => CollectionCubit(getIt.get<CollectionRepoImpl>()),
              child: Builder(builder: (_) => const CollectionView()),
            );
          },
        );
      },
    );
  }
}