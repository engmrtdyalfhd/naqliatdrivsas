import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/auth/data/user_model.dart';
import '../../feature/collection/data/repo/collection_repo.dart';
import '../../feature/collection/manager/collection_cubit.dart';
import 'constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../feature/home/ui/view/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../feature/auth/ui/view/onboarding_view.dart';
import '../../feature/collection/ui/view/collection_view.dart';
import '../service/service_locator.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        // 1. حالة التحميل الأساسية (Firebase Auth)
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold();
        }

        // 2. إذا لم يسجل دخول، يذهب للأونبوردنج
        if (authSnapshot.data == null) return const OnboardingView();

        // 3. إذا سجل دخول بالهاتف، نتحقق الآن من بياناته في Firestore
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection(FirebaseStr.driversCollection)
              .doc(authSnapshot.data?.uid)
              .get(),
          builder: (context, dbSnapshot) {
            // حالة انتظار جلب البيانات من الداتابيز
            if (dbSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold();
            }

            if (dbSnapshot.hasError) {
              return Scaffold(
                body: Center(child: Text("Oops! Auth gate error.")),
              );
            }

            // التحقق هل البيانات (collectionAtt) موجودة؟
            final user = UserModel.fromJson(
              dbSnapshot.data?.data() as Map<String, dynamic>,
            );
            final bool hasData =
                dbSnapshot.data != null &&
                dbSnapshot.data!.exists &&
                user.truck != null;

            if (hasData) {
              return const HomeView(); // البيانات كاملة -> الهوم
            } else {
              return BlocProvider<CollectionCubit>(
                create: (_) => CollectionCubit(getIt.get<CollectionRepoImpl>()),
                child: const CollectionView(),
              ); // البيانات ناقصة -> صفحة إدخال البيانات
            }
          },
        );
      },
    );
  }
}
