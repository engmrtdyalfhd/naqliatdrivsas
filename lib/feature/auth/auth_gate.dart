import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naqliatdrivsas/feature/collection/domain/usecase/get_collection_usecase.dart';
import 'package:naqliatdrivsas/feature/collection/domain/usecase/update_truck_usecase.dart';
import 'package:naqliatdrivsas/feature/collection/presentation/cubit/collection_cubit.dart';
import 'package:naqliatdrivsas/feature/collection/presentation/view/collection_view.dart';
import 'package:naqliatdrivsas/feature/home/ui/view/home_view.dart';

import '../../../core/helper/constant.dart';
import '../../../core/service/service_locator.dart';
import 'data/model/user_model.dart';

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

        // ✅ Not authenticated → redirect to Login ROUTE (not embed LoginView).
        //    The Login route owns AuthCubit so it lives for the whole OTP flow.
        if (authSnapshot.data == null) {
          return const _RedirectToLogin();
        }

        // ✅ Authenticated → resolve the Firestore state.
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
                body: Center(child: Text('Oops! Something went wrong.')),
              );
            }

            // Document missing → sign out and redirect to login.
            if (dbSnapshot.data == null || !dbSnapshot.data!.exists) {
              FirebaseAuth.instance.signOut();
              return const _RedirectToLogin();
            }

            final docData =
            dbSnapshot.data!.data() as Map<String, dynamic>?;

            // Driver has a truck → go home.
            if (docData != null &&
                docData[FirebaseStr.driverTruck] != null) {
              try {
                final user = UserModel.fromJson(docData);
                if (user.truck != null) return const HomeView();
              } catch (_) {}
            }

            // Driver signed in but hasn't set up their truck yet.
            return BlocProvider<CollectionCubit>(
              create: (_) => CollectionCubit(getCollection: getIt<GetCollectionUseCase>(),updateTruck: getIt<UpdateTruckUseCase>()),
              child: const CollectionView(),
            );
          },
        );
      },
    );
  }
}

/// Redirects to the login route after the current frame, so AuthGate never
/// embeds LoginView (and therefore never owns AuthCubit).
class _RedirectToLogin extends StatefulWidget {
  const _RedirectToLogin();

  @override
  State<_RedirectToLogin> createState() => _RedirectToLoginState();
}

class _RedirectToLoginState extends State<_RedirectToLogin> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        RoutePath.login,
            (_) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}