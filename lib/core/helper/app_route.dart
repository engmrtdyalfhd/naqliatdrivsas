import 'package:naqliatsa/feature/location/data/repo/location_repo.dart';
import 'package:naqliatsa/feature/location/manager/location_cubit.dart';
import 'package:naqliatsa/feature/location/ui/screen/location_screen.dart';
import 'package:naqliatsa/feature/search/data/cubits/search_cubit.dart';
import 'package:naqliatsa/feature/search/data/repo/shipment_repository.dart';
import 'package:naqliatsa/feature/search/ui/view/search_page.dart';

import '../../feature/collection/data/repo/collection_repo.dart';
import '../../feature/collection/manager/collection_cubit.dart';
import '../../feature/collection/ui/view/collection_view.dart';
import 'constant.dart';
import 'auth_gate.dart';
import 'custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../feature/auth/ui/view/login_view.dart';
import '../../feature/auth/manager/auth_cubit.dart';
import '../../feature/settings/view/profile_view.dart';
import '../../feature/auth/ui/view/verify_phone_view.dart';
import '../service/service_locator.dart';

// ! _____ App Routes Here (OnGenerate Approach) _____ ! //
class AppRoutes {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.authGate:
        return CustomPageRoute(child: const AuthGate());
      case RoutePath.login:
        return CustomPageRoute(
          child: BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(),
            child: const LoginView(),
          ),
        );
      case RoutePath.verifyPhone:
        return CustomPageRoute(child: const VerifyPhoneView());
      case RoutePath.collection:
        return CustomPageRoute(
          child: BlocProvider<CollectionCubit>(
            create: (context) =>
                CollectionCubit(getIt.get<CollectionRepoImpl>()),
            child: const CollectionView(),
          ),
        );
      case RoutePath.searchpage:
        return CustomPageRoute(
          child: BlocProvider<SearchCubit>(
            create: (context) =>
                SearchCubit(getIt.get<ShipmentRepositoryImpl>()),
            child: const SearchPage(),
          ),
        );
      case RoutePath.profile:
        return CustomPageRoute(child: const ProfileView());
      case RoutePath.locationScreen:
        return CustomPageRoute(
          child: BlocProvider<LocationCubit>(
            create: (context) =>
                LocationCubit(getIt.get<LocationRepo>())..init(),
            child: const LocationScreen(),
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
