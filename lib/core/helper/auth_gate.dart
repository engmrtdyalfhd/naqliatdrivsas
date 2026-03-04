import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/auth/data/user_model.dart';
import '../../feature/auth/manager/auth_cubit.dart';
import '../../feature/auth/ui/view/login_view.dart';
import '../../feature/collection/data/repo/collection_repo.dart';
import '../../feature/collection/manager/collection_cubit.dart';
import '../../feature/collection/ui/view/collection_view.dart';
import '../../feature/home/ui/view/home_view.dart';
import '../service/service_locator.dart';
import 'constant.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold();
        }

        if (authSnapshot.data == null) {
          return BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(),
            child: Builder(builder: (_) => const LoginView()),
          );
        }

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

            if (dbSnapshot.data == null || !dbSnapshot.data!.exists) {
              // Option A: Sign them out and send to login
              FirebaseAuth.instance.signOut();
              return BlocProvider<AuthCubit>(
                create: (_) => AuthCubit(),
                child: Builder(builder: (_) => const LoginView()),
              );
            }

            final docData = dbSnapshot.data!.data() as Map<String, dynamic>?;
            final bool hasTruck = docData != null && docData['truck'] != null;

            if (hasTruck) {
              try {
                final user = UserModel.fromJson(docData);
                if (user.truck != null) return const HomeView();
              } catch (_) {}
            }

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
