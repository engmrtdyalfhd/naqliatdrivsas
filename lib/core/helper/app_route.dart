// lib/core/helper/app_route.dart
import '../../feature/collection/data/repo/collection_repo.dart';
import '../../feature/collection/manager/collection_cubit.dart';
import '../../feature/collection/ui/view/collection_view.dart';
import '../../feature/auth/manager/auth_cubit.dart';
import '../../feature/auth/ui/view/login_view.dart';
import '../../feature/auth/ui/view/verify_phone_view.dart';
import '../../feature/location/data/repo/location_repo.dart';
import '../../feature/location/manager/location_cubit.dart';
import '../../feature/location/ui/screen/location_screen.dart';
import '../../feature/search/data/cubits/search_cubit.dart';
import '../../feature/search/data/repo/shipment_repository.dart';
import '../../feature/search/ui/view/search_page.dart';
import '../../feature/settings/view/profile_view.dart';
import 'constant.dart';
import 'auth_gate.dart';
import 'custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/service_locator.dart';

class AppRoutes {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case RoutePath.authGate:
        return CustomPageRoute(child: const AuthGate());

    // Login and VerifyPhone share the SAME AuthCubit instance.
    // It is created here at the route level so it is NOT disposed
    // when LoginView pushes VerifyPhoneView — preventing the
    // "Cannot emit new states after calling close" crash.
      case RoutePath.login:
        return CustomPageRoute(
          child: BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(),
            child: const LoginView(),
          ),
        );

      case RoutePath.verifyPhone:
      // VerifyPhoneView is pushed from LoginView using BlocProvider.value,
      // so it reuses the AuthCubit already in the tree.
        return CustomPageRoute(child: const VerifyPhoneView());

      case RoutePath.collection:
        return CustomPageRoute(
          child: BlocProvider<CollectionCubit>(
            create: (_) => CollectionCubit(getIt.get<CollectionRepoImpl>()),
            child:  CollectionView(),
          ),
        );

      case RoutePath.searchpage:
        return CustomPageRoute(
          child: BlocProvider<SearchCubit>(
            create: (_) => SearchCubit(getIt.get<ShipmentRepositoryImpl>()),
            child:  const SearchPage(),
          ),
        );

      case RoutePath.profile:
        return CustomPageRoute(child: const ProfileView());

      case RoutePath.locationScreen:
        return CustomPageRoute(
          child: BlocProvider<LocationCubit>(
            create: (_) => LocationCubit(getIt.get<LocationRepo>())..init(),
            child:  LocationScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined for this path')),
          ),
        );
    }
  }
}